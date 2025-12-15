"use strict";

function initTeXViewMobile(flutterTeXData) {
    var teXViewElement = document.getElementById('TeXView');
    teXViewElement.innerHTML = '';
    teXViewElement.appendChild(createTeXView(flutterTeXData), teXViewElement, "", false);
    renderTeXView(() => renderCompleted(teXViewElement, "", false));
}

function initTeXViewWeb(iframeContentWindow, iframeId, flutterTeXData) {
    var teXViewElement = iframeContentWindow.document.getElementById('TeXView');
    teXViewElement.innerHTML = '';
    teXViewElement.appendChild(createTeXView(JSON.parse(flutterTeXData), teXViewElement, iframeId, true));
    iframeContentWindow.renderTeXView(() => renderCompleted(teXViewElement, iframeId, true));
}

function createTeXView(rootData, teXViewElement, iframeId, isWeb) {

    var meta = rootData['meta'];
    var data = rootData['data'];
    var id = meta['id']
    var classList = meta['classList'];

    var element = document.createElement(meta['tag']);
    element.classList.add(classList);
    element.setAttribute('style', rootData['style']);
    element.setAttribute('id', id)

    switch (meta['node']) {
        case 'root': {
            element.appendChild(createTeXView(data, teXViewElement, iframeId, isWeb));
            break;
        }
        case 'leaf': {
            if (meta['tag'] === 'img') {
                if (classList === 'tex-view-asset-image') {
                    element.setAttribute('src', '../../../' + data);
                } else {
                    element.setAttribute('src', data);
                    element.addEventListener("load", () =>
                        renderCompleted(teXViewElement, iframeId, isWeb)

                    );
                }
            } else {
                element.innerHTML = data;
            }
            break;
        }
        case 'internal_child': {
            element.appendChild(createTeXView(data, teXViewElement, iframeId, isWeb));
            if (classList === 'tex-view-ink-well') clickManager(iframeId, element, id, rootData['rippleEffect'], isWeb);
            break;
        }

        default: {
            if (classList === 'tex-view-group') {
                createTeXViewGroup(element, rootData, teXViewElement, iframeId, isWeb);
            } else if (classList === 'tex-view-group-multiple') {
                createTeXViewGroupMultiple(element, rootData, teXViewElement, iframeId, isWeb);
            }
            else {
                data.forEach(function (childViewData) {
                    if (classList === 'tex-view-group') {
                        createTeXViewGroup(element, rootData, teXViewElement, iframeId, isWeb);
                    } else if (classList === 'tex-view-group-multiple') {
                        createTeXViewGroupMultiple(element, rootData, teXViewElement, iframeId, isWeb);
                    }
                    else {
                        data.forEach(function (childViewData) {
                            element.appendChild(createTeXView(childViewData, teXViewElement, iframeId, isWeb));
                        });
                    }
                });
            }
        }
    }
    return element;
}
function createTeXViewGroup(element, rootData, teXViewElement, iframeId, isWeb) {
    var normalStyle = rootData['normalItemStyle'];
    var selectedStyle = rootData['selectedItemStyle'];
    var single = rootData['single'];
    var lastSelected;
    var lastSelectedId = rootData["lastSelectedId"];
    var selectedIds = rootData["selectedIds"] || [];
    var programmaticallySelectedId = rootData["selectedItemId"];

    rootData['data'].forEach(function (data) {
        data['style'] = normalStyle;
        var item = createTeXView(data, teXViewElement, iframeId, isWeb);
        var id = data['meta']['id'];
        item.setAttribute('id', id);

        if (single) {
            if (id === programmaticallySelectedId || id === lastSelectedId) {
                item.setAttribute("style", selectedStyle);
                lastSelected = item;
                lastSelectedId = id;
            }
        } else {
            if (arrayContains(selectedIds, id) || id === programmaticallySelectedId) {
                item.setAttribute("style", selectedStyle);
                if (!arrayContains(selectedIds, id)) {
                    selectedIds.push(id);
                }
            }
        }

        item.addEventListener('click', function () {
            if (single) {
                if (lastSelected != null) lastSelected.setAttribute('style', normalStyle);
                item.setAttribute('style', selectedStyle);
                lastSelected = item;
                lastSelectedId = id;
                if (isWeb) {
                    OnTapCallback(id, iframeId);
                } else {
                    OnTapCallback.postMessage(id);
                }
            } else {
                if (arrayContains(selectedIds, id)) {
                    document.getElementById(id).setAttribute('style', normalStyle);
                    selectedIds.splice(selectedIds.indexOf(id), 1)
                } else {
                    document.getElementById(id).setAttribute('style', selectedStyle);
                    selectedIds.push(id);
                }
                if (isWeb) {
                    OnTapCallback(JSON.stringify(selectedIds), iframeId);
                } else {
                    OnTapCallback.postMessage(JSON.stringify(selectedIds));
                }
            }
            renderCompleted(teXViewElement, iframeId, isWeb);
        })
        element.appendChild(item);
    });
}

function createTeXViewGroupMultiple(element, rootData, teXViewElement, iframeId, isWeb) {
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
        const item = createTeXView(data, teXViewElement, iframeId, isWeb);
        item.setAttribute('style', normalStyle);

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

            if (isWeb) {
                OnTapCallback(JSON.stringify(callbackData), iframeId);
            } else {
                OnTapCallback.postMessage(JSON.stringify(callbackData));
            }
            renderCompleted(teXViewElement, iframeId, isWeb);
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

function renderCompleted(texViewElement, iframeId, isWeb) {
    let lastHeight;

    function execute() {
        const height = getTeXViewHeight(texViewElement);
        const rendered = lastHeight === height;
        lastHeight = height;

        if (isWeb) {
            OnTeXViewRenderedCallback(height, iframeId);
        } else {
            OnTeXViewRenderedCallback.postMessage(height);
        }

        if (!rendered) {
            console.log('TeXView not fully rendered yet! Retrying in 250ms...');
            setTimeout(() => execute(texViewElement), 250);
        }
    }
    execute();
}

function clickManager(iframeId, element, id, rippleEffect, isWeb) {
    element.addEventListener('click', function (e) {

        if (isWeb) {
            OnTapCallback(id, iframeId);
        } else {
            OnTapCallback.postMessage(id);
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