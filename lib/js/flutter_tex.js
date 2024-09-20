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
            } else {
                data.forEach(function (childViewData) {
                    element.appendChild(createTeXView(childViewData))
                });
            }
        }
    }
    return element;
}

// function createTeXViewGroup(element, rootData) {

//     var normalStyle = rootData['normalItemStyle'];
//     var selectedStyle = rootData['selectedItemStyle'];
//     var single = rootData['single'];
//     var lastSelected;
//     var lastSelectedId = rootData["lastSelectedId"];
//     var selectedIds = rootData["selectedIds"];
//     if (selectedIds == null) {
//       selectedIds = [];
//     }

//     rootData['data'].forEach(function (data) {
//         data['style'] = normalStyle;
//         var item = createTeXView(data);
//         var id = data['meta']['id'];
//         item.setAttribute('id', id);

//         if (single) {
//             if (lastSelectedId != null) {
//                 if (id === lastSelectedId) {
//                     item.setAttribute("style", selectedStyle);
//                     lastSelected = item;
//                 }
//             }
//         } else {
//             if (selectedIds != null) {
//                     if (arrayContains(selectedIds, id)) {
//                     item.setAttribute("style", selectedStyle);
//                 }
//             }
//         }

//         clickManager(item, id, rootData['rippleEffect'], function (clickedId) {
//             if (clickedId === id) {
//                 if (single) {
//                     if (lastSelected != null) lastSelected.setAttribute('style', normalStyle);
//                     item.setAttribute('style', selectedStyle);
//                     lastSelected = item;
//                     onTapCallback(clickedId);
//                 } else {
//                     if (arrayContains(selectedIds, clickedId)) {
//                         document.getElementById(clickedId).setAttribute('style', normalStyle);
//                         selectedIds.splice(selectedIds.indexOf(clickedId), 1)
//                     } else {
//                         document.getElementById(clickedId).setAttribute('style', selectedStyle);
//                         selectedIds.push(clickedId);
//                     }
//                     onTapCallback(JSON.stringify(selectedIds));
//                 }
//             }
//             renderCompleted();
//         })
//         element.appendChild(item);
//     });
// }


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
function _toggleAudio(id, audioIcon) {
    const audioContainer = document.getElementById(id);
    const children = audioContainer.getElementsByClassName(
        "tex-view-asset-image"
    );
    if (children.length > 0) {
        const audio = children.item(0)
        audio.src = getAssetsUri() + audioIcon
    }
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
