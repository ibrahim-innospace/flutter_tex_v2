"use strict";
var isWeb = false;
var teXView;
var iFrameWeb;
var renderingEngine;

function initTeXView(jsonData, engine) {
    renderingEngine = engine;
    teXView.innerHTML = '';
    teXView.appendChild(createTeXView(jsonData));
    renderTeXView(renderCompleted);
}

function initWebTeXView(viewId, rawData, engine) {
    isWeb = true
    renderingEngine = engine;
    var initiated = false;
    iFrameWeb = document.getElementById(viewId);
    if (iFrameWeb != null) {
        var iFrame = iFrameWeb.contentWindow;
        if (iFrame != null) {
            teXView = iFrame.document.getElementById('TeXView');
            if (teXView != null) {
                teXView.innerHTML = "";
                initiated = true;
                var jsonData = JSON.parse(rawData);
                teXView.appendChild(createTeXView(jsonData));
                iFrame.renderTeXView(renderCompleted);
            }
        }
    }

    if (!initiated) setTimeout(function () {
        initWebTeXView(viewId, rawData)
    }, 250);
}

function createTeXView(rootData) {
    var meta = rootData['meta'];
    var data = rootData['data'];
    var id = meta['id']
    var classList = meta['classList'];
    var element = document.createElement(meta['tag']);
    element.classList.add(classList);
    element.setAttribute('style', rootData['style']);
    element.setAttribute('id', id)

    switch (meta['node']) {
        case 'leaf': {
            if (meta['tag'] === 'img') {
                if (classList === 'tex-view-asset-image') {
                    element.setAttribute('src', getAssetsUri() + data);
                } else {
                    element.setAttribute('src', data);
                    element.addEventListener("load", renderCompleted);
                }
            } else {
                element.innerHTML = data;
            }
        }
            break;
        case 'internal_child': {
            element.appendChild(createTeXView(data))

            // Handle TeXViewGroupItem clicks
            if (classList === 'tex-view-group-item') {
                handleGroupItemClick(element, rootData);
            } else if (classList === 'tex-view-ink-well') {
                clickManager(element, id, rootData['rippleEffect']);
            }
        }
            break;
        case 'root':
            rootData['fonts'].forEach(function (font) {
                registerFont(font['font_family'], font['src'])
            })
            element.appendChild(createTeXView(data));
            break;
        default: {
            if (classList === 'tex-view-group') {
                createTeXViewGroup(element, rootData);
            } else if (classList === 'tex-view-group-multiple') {
                createTeXViewGroupMultiple(element, rootData);
            }
            else {
                data.forEach(function (childViewData) {
                    element.appendChild(createTeXView(childViewData))
                });
            }
        }
    }
    return element;
}

function handleGroupItemClick(element, itemData) {
    var id = itemData['meta']['id'];
    var rippleEffect = itemData['rippleEffect'] !== false;

    // Only add click handler if item is not disabled
    if (itemData['onTap'] !== null) {
        clickManager(element, id, rippleEffect, function (clickedId) {
            // The item manages its own style changes
            onTapCallback(clickedId);
            renderCompleted();
        });
    }
}

function createTeXViewGroup(element, rootData) {
    var single = rootData['single'];
    var selectedIds = rootData['selectedIds'] || [];
    var groupItems = [];

    rootData['data'].forEach(function (itemData) {
        var item = createTeXView(itemData);
        var itemId = itemData['meta']['id'];
        var isSelected = itemData['isSelected'] || arrayContains(selectedIds, itemId);

        // Store reference to items for group management
        groupItems.push({
            element: item,
            id: itemId,
            data: itemData
        });

        element.appendChild(item);
    });

    // If single selection mode, manage exclusive selection
    if (single) {
        element.addEventListener('click', function (e) {
            // Find which item was clicked
            var clickedItem = null;
            groupItems.forEach(function (groupItem) {
                if (groupItem.element.contains(e.target)) {
                    clickedItem = groupItem;
                }
            });

            if (clickedItem && single) {
                // Deselect all other items
                groupItems.forEach(function (groupItem) {
                    if (groupItem.id !== clickedItem.id) {
                        var normalStyle = groupItem.data['normalStyle'] ||
                            rootData['normalItemStyle'];
                        if (normalStyle) {
                            groupItem.element.setAttribute('style', normalStyle);
                        }
                    }
                });
            }
        }, true); // Use capture phase to handle before item click
    }
}

function createTeXViewGroupMultiple(element, rootData) {
    const normalStyle = rootData['normalItemStyle'];
    const selectedStyle = rootData['selectedItemStyle'];
    const groupId = rootData['groupId'];
    let selectedIds = rootData['selectedItemIds'] || [];

    // Create group container with unique ID
    const groupContainer = document.createElement('div');
    groupContainer.id = `texview-group-${groupId}`;
    groupContainer.setAttribute('data-group-id', groupId);
    element.appendChild(groupContainer);

    // Store group state
    const groupState = {
        selectedIds: [...selectedIds],
        container: groupContainer
    };

    // Create items
    rootData['data'].forEach(function (data) {
        const item = createTeXView({
            ...data,
            style: normalStyle
        });

        const itemId = data['meta']['id'];
        item.setAttribute('id', itemId);
        item.setAttribute('data-group-id', groupId);

        // Set initial selection state
        if (selectedIds.includes(itemId)) {
            item.setAttribute('style', selectedStyle);
        }

        // Add click handler
        item.addEventListener('click', function (e) {
            e.stopPropagation(); // Prevent event bubbling

            const currentGroupId = this.getAttribute('data-group-id');
            if (currentGroupId !== groupId) return;

            const isSelected = groupState.selectedIds.includes(itemId);

            if (isSelected) {
                // Deselect
                this.setAttribute('style', normalStyle);
                groupState.selectedIds = groupState.selectedIds.filter(id => id !== itemId);
            } else {
                // Select
                this.setAttribute('style', selectedStyle);
                groupState.selectedIds.push(itemId);
            }

            // Send callback with group information
            const callbackData = {
                groupId: groupId,
                selectedIds: groupState.selectedIds
            };

            onTapCallback(JSON.stringify(callbackData));
            renderCompleted();
        });

        groupContainer.appendChild(item);
    });
}

function arrayContains(array, obj) {
    var i = array.length;
    while (i--) {
        if (array[i] === obj) {
            return true;
        }
    }
    return false;
}

function renderCompleted() {
    var height = getTeXViewHeight(teXView);

    if (renderingEngine = "katex") height += 5;

    if (isWeb) {
        TeXViewRenderedCallback(height);
    } else {
        TeXViewRenderedCallback.postMessage(height);
    }
}

function clickManager(element, id, rippleEffect, callback) {
    element.addEventListener('click', function (e) {
        if (callback != null) {
            callback(id);
        } else {
            onTapCallback(id);
        }

        if (rippleEffect) {
            var ripple = document.createElement('div');
            this.appendChild(ripple);
            var d = Math.max(this.clientWidth, this.clientHeight);
            ripple.style.width = ripple.style.height = d + 'px';
            var rect = this.getBoundingClientRect();
            ripple.style.left = e.clientX - rect.left - d / 2 + 'px';
            ripple.style.top = e.clientY - rect.top - d / 2 + 'px';
            ripple.classList.add('ripple');
        }
    });
}

function onTapCallback(message) {
    if (isWeb) {
        OnTapCallback(message);
    } else {
        OnTapCallback.postMessage(message);
    }
}

function getTeXViewHeight(view) {
    var element = view;
    var height = element.offsetHeight,
        style = window.getComputedStyle(element)
    return ['top', 'bottom']
        .map(function (side) {
            return parseInt(style["margin-" + side]);
        })
        .reduce(function (total, side) {
            return total + side;
        }, height)
}

function registerFont(fontFamily, src) {
    var registerFont =
        ' @font-face {                               \n' +
        '   font-family: ' + fontFamily + ';         \n' +
        '   src: url(' + getAssetsUri() + src + ');  \n' +
        ' }';
    appendStyle(registerFont);
}

function getAssetsUri() {
    var currentUrl = location.protocol + '//' + location.host;
    var uri;
    if (isWeb) {
        uri = currentUrl + '/assets/';
    } else {
        uri = currentUrl + '/';
    }
    return uri
}

function appendStyle(content) {
    var style = document.createElement('STYLE');
    style.type = 'text/css';
    style.appendChild(document.createTextNode(content));
    document.head.appendChild(style);
}