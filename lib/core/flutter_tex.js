"use strict";
var isWeb = false;
var teXView;


function initTeXView(rawData) {
    teXView = document.getElementById('TeXView');
    teXView.innerHTML = '';
    teXView.appendChild(createTeXView(rawData));
    renderTeXView(renderCompleted);
}

function initWebTeXView(viewId, rawData) {
    isWeb = true
    var initiated = false;
    var iframeElement = document.getElementById(viewId);
    if (iframeElement) {
        var iframeContent = iframeElement.contentWindow;
        if (iframeContent) {
            teXView = iframeContent.document.getElementById('TeXView');
            if (teXView) {
                teXView.innerHTML = '';
                teXView.appendChild(createTeXView(JSON.parse(rawData)));
                var renderTeXViewFn = iframeContent.renderTeXView;
                if (renderTeXViewFn) {
                    renderTeXViewFn(renderCompleted);
                    initiated = true;
                }
            }
        }
    }

    if (!initiated) setTimeout(function () {
        initWebTeXView(viewId, rawData)
    }, 100);
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
            if (classList === 'tex-view-ink-well') clickManager(element, id, rootData['rippleEffect']);
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
            } else {
                data.forEach(function (childViewData) {
                    element.appendChild(createTeXView(childViewData))
                });
            }
        }
    }
    return element;
}

function createTeXViewGroup(element, rootData) {
    var normalStyle = rootData['normalItemStyle'];
    var selectedStyle = rootData['selectedItemStyle'];
    var single = rootData['single'];
    var lastSelected;
    var lastSelectedId = rootData["lastSelectedId"];
    var selectedIds = rootData["selectedIds"] || [];
    var programmaticallySelectedId = rootData["selectedItemId"]; // Add this line

    rootData['data'].forEach(function (data) {
        data['style'] = normalStyle;
        var item = createTeXView(data);
        var id = data['meta']['id'];
        item.setAttribute('id', id);

        if (single) {
            if (id === programmaticallySelectedId || id === lastSelectedId) { // Modified this line
                item.setAttribute("style", selectedStyle);
                lastSelected = item;
                lastSelectedId = id;
            }
        } else {
            if (arrayContains(selectedIds, id) || id === programmaticallySelectedId) { // Modified this line
                item.setAttribute("style", selectedStyle);
                if (!arrayContains(selectedIds, id)) {
                    selectedIds.push(id);
                }
            }
        }

        clickManager(item, id, rootData['rippleEffect'], function (clickedId) {
            if (clickedId === id) {
                if (single) {
                    if (lastSelected != null) lastSelected.setAttribute('style', normalStyle);
                    item.setAttribute('style', selectedStyle);
                    lastSelected = item;
                    lastSelectedId = clickedId;
                    onTapCallback(clickedId);
                } else {
                    if (arrayContains(selectedIds, clickedId)) {
                        document.getElementById(clickedId).setAttribute('style', normalStyle);
                        selectedIds.splice(selectedIds.indexOf(clickedId), 1)
                    } else {
                        document.getElementById(clickedId).setAttribute('style', selectedStyle);
                        selectedIds.push(clickedId);
                    }
                    onTapCallback(JSON.stringify(selectedIds));
                }
            }
            renderCompleted();
        })
        element.appendChild(item);
    });
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

let lastHeight = 0;

function renderCompleted() {
    const height = getTeXViewHeight(teXView);
    const rendered = lastHeight === height;
    lastHeight = height;

    if (isWeb) {
        TeXViewRenderedCallback(height);
    } else {
        TeXViewRenderedCallback.postMessage(height);
    }

    if (!rendered) {
        console.log('TeXView not fully rendered yet! Retrying in 250ms...');
        setTimeout(renderCompleted, 250);
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
    var height = view.offsetHeight,
        style = window.getComputedStyle(view)
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


(function () {

    (function () {
        // Load MathJax configuration.
        var mathjax_config_script = document.createElement('script');
        mathjax_config_script.src = getAssetsUri() + 'assets/mathjax_config.js';
        mathjax_config_script.async = false;
        document.head.appendChild(mathjax_config_script);

        // Load MathJax core script.
        var mathjax_core_script = document.createElement('script');
        mathjax_core_script.src = "mathjax_core.js";
        mathjax_core_script.id = "MathJax-script";
        mathjax_core_script.async = false;
        document.head.appendChild(mathjax_core_script);
    })();

})();