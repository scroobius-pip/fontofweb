var SrcTypes = /*#__PURE__*/ (function (SrcTypes) {
    SrcTypes["eot"] = "eot";
    SrcTypes["ttf"] = "ttf";
    SrcTypes["otf"] = "otf";
    SrcTypes["woff2"] = "woff2";
    SrcTypes["woff"] = "woff";
    SrcTypes["other"] = "other";
    return SrcTypes;
})(SrcTypes || {});
document.addEventListener("DOMContentLoaded", () => {
    const fontInfo = getFontInfo();
    console.log(fontInfo)
    window.parent.postMessage(fontInfo, "https://www.fontofweb.com");
});
const getFontInfo = () => {
    const convertFontVariantToString = ({ lineHeight, size, weight }) =>
        [normalizeLineHeight(lineHeight), size, weight].join("|");
    const convertStringToFontVariant = (string) => {
        const [lineHeight, size, weight] = string.split("|");
        return {
            lineHeight: normalizeLineHeight(lineHeight),
            size,
            weight
        };
    };
    const selectFontSrc = (font) => {
        var _ref, _ref2, _ref3, _ref4, _font$ttf;
        return (_ref =
            (_ref2 =
                (_ref3 =
                    (_ref4 =
                        (_font$ttf =
                            font === null || font === void 0 ? void 0 : font.ttf) !== null &&
                            _font$ttf !== void 0
                            ? _font$ttf
                            : font === null || font === void 0
                                ? void 0
                                : font.otf) !== null && _ref4 !== void 0
                        ? _ref4
                        : font === null || font === void 0
                            ? void 0
                            : font.eot) !== null && _ref3 !== void 0
                    ? _ref3
                    : font === null || font === void 0
                        ? void 0
                        : font.woff) !== null && _ref2 !== void 0
                ? _ref2
                : font === null || font === void 0
                    ? void 0
                    : font.woff2) !== null && _ref !== void 0
            ? _ref
            : Object.values(font)[0];
    };
    function inBlackList(fontName) {
        const blacklist = ["icon", "slick", "awesome", "etmodules", "video"];
        const lowerFontName = fontName.toLowerCase();
        return blacklist.some((value) => {
            return lowerFontName.includes(value);
        });
    }
    function normalizeLineHeight(lineHeight) {
        return lineHeight === "normal" ? "1.2" : lineHeight;
    }
    function getSrcExtension(s) {
        return s.split(".").pop();
    }
    function getSrcObjName(extension) {
        return extension.length > 5 ? "other" : extension;
    }
    function extractFontUrls(s) {
        if (!s) return [];
        const srcs = s.split(",");
        return srcs
            .map((src) => {
                var _src$match;
                const urls =
                    (_src$match = src.match(/(?<=")(.*\.(ttf|woff2|woff|otf|eot))/g)) !==
                        null && _src$match !== void 0
                        ? _src$match
                        : [];
                return urls;
            })
            .filter(Boolean)
            .flat();
    }
    function getFontSrcMap(tidyFontName, getParentPath) {
        const map = new Map();
        const documentStylesheets = [...document.styleSheets];
        const getCssRules = (cssRule) => {
            try {
                if (cssRule instanceof CSSFontFaceRule) {
                    var _cssRule$parentStyleS, _style;
                    if (
                        !(
                            cssRule !== null &&
                            cssRule !== void 0 &&
                            (_cssRule$parentStyleS = cssRule.parentStyleSheet) !== null &&
                            _cssRule$parentStyleS !== void 0 &&
                            _cssRule$parentStyleS.href
                        )
                    )
                        return;
                    map.set(tidyFontName(cssRule.style.fontFamily), {
                        src:
                            (_style = cssRule.style) === null || _style === void 0
                                ? void 0
                                : _style.src,
                        parentPath: getParentPath(cssRule.parentStyleSheet.href)
                    });
                    return;
                }
                if (cssRule instanceof CSSMediaRule) {
                    const nestedCssRules = [...cssRule.cssRules];
                    nestedCssRules.forEach(getCssRules);
                    return;
                }
                if (cssRule instanceof CSSImportRule) {
                    const nestedStylesheet = cssRule.styleSheet;
                    if (!nestedStylesheet) return;
                    const nestedCssRules = [...nestedStylesheet.cssRules];
                    nestedCssRules.forEach(getCssRules);
                    return;
                }
            } catch (error) {
                console.error(error);
                console.log("continuing");
            }
        };
        documentStylesheets.forEach((documentStylesheet) => {
            try {
                const cssRules = [
                    ...(documentStylesheet === null || documentStylesheet === void 0
                        ? void 0
                        : documentStylesheet.cssRules)
                ];
                cssRules.forEach(getCssRules);
            } catch (error) {
                console.error('unable to get rules:', error, documentStylesheet.href)
            }
        });
        return map;
    }
    function getFontNamesAndFallbacks(fontFamily, srcMap) {
        //returns a font name, an apple version and fallbacks

        const appleFonts = ["-apple-system", "BlinkMacSystemFont"];
        const appleFont = fontFamily.filter((fontName) =>
            appleFonts.includes(fontName)
        )[0];
        const universalFonts = fontFamily.filter(
            (fontName) => !appleFonts.includes(fontName)
        );
        const chosenUniversalFont = (() => {
            for (const universalFont of universalFonts) {
                if (srcMap.has(universalFont)) {
                    return universalFont;
                }
            }
            return universalFonts[0];
        })();
        const fallbacks = fontFamily.filter(
            (fontName) => ![appleFont, chosenUniversalFont].includes(fontName)
        );
        return [fallbacks, appleFont, chosenUniversalFont];
    }
    const initGetElementFontData = () => {
        const srcMap = getFontSrcMap(tidyFontName, getParentPath);
        return (element) => {
            const fontMap = new Map();
            const fallbackMap = new Map();
            const getFontVariant = ({ fontWeight, lineHeight, fontSize }) => ({
                lineHeight,
                size: fontSize,
                weight: fontWeight
            });
            const pseudoElements = ["", ":before", ":after"];
            pseudoElements.forEach((pseudo) => {
                var _elementStyle$fontFam;
                const elementStyle = window.getComputedStyle(element, pseudo);
                if (
                    !(
                        elementStyle !== null &&
                        elementStyle !== void 0 &&
                        elementStyle.fontFamily
                    )
                )
                    return;
                const splitFontFamily =
                    (_elementStyle$fontFam =
                        elementStyle === null || elementStyle === void 0
                            ? void 0
                            : elementStyle.fontFamily.split(/\n*,\n*/g).map(tidyFontName)) !==
                        null && _elementStyle$fontFam !== void 0
                        ? _elementStyle$fontFam
                        : [];
                const [fallbacks, ...fontNames] = getFontNamesAndFallbacks(
                    splitFontFamily,
                    srcMap
                );
                for (const fontName of fontNames) {
                    var _fontMap$get, _fallbackMap$get;
                    if (!fontName) continue;
                    const fontVariantArray =
                        (_fontMap$get = fontMap.get(fontName)) !== null &&
                            _fontMap$get !== void 0
                            ? _fontMap$get
                            : [];
                    fontVariantArray.push(getFontVariant(elementStyle));
                    if (inBlackList(fontName)) return;
                    fontMap.set(fontName, fontVariantArray);
                    fallbackMap.set(fontName, [
                        ...((_fallbackMap$get = fallbackMap.get(fontName)) !== null &&
                            _fallbackMap$get !== void 0
                            ? _fallbackMap$get
                            : []),
                        ...fallbacks
                    ]);
                }
            });
            const value = (() => {
                let elementFontData = {};
                fontMap.forEach((variants, fontName) => {
                    var _srcMap$get;
                    const { parentPath, src } =
                        (_srcMap$get = srcMap.get(fontName)) !== null &&
                            _srcMap$get !== void 0
                            ? _srcMap$get
                            : {
                                parentPath: "",
                                src: ""
                            };
                    const srcArray = extractFontUrls(src);
                    const srcObj = srcArray.reduce((srcObj, s) => {
                        const extension = getSrcExtension(s);
                        //@ts-ignore
                        srcObj[getSrcObjName(extension)] = joinBaseUrl(
                            s,
                            parentPath !== null && parentPath !== void 0
                                ? parentPath
                                : window.location.href
                        );
                        return srcObj;
                    }, {});
                    if (fontName in elementFontData) {
                        var _elementFontData$font, _elementFontData$font2;
                        elementFontData = {
                            ...elementFontData,
                            [fontName]: {
                                ...elementFontData[fontName],
                                variants: [
                                    ...((_elementFontData$font = elementFontData[fontName]) ===
                                        null || _elementFontData$font === void 0
                                        ? void 0
                                        : _elementFontData$font.variants),
                                    ...variants
                                ],
                                src: {
                                    ...((_elementFontData$font2 = elementFontData[fontName]) ===
                                        null || _elementFontData$font2 === void 0
                                        ? void 0
                                        : _elementFontData$font2.src),
                                    ...srcObj
                                }
                            }
                        };
                        return;
                    } else {
                        var _fallbackMap$get2;
                        elementFontData = {
                            ...elementFontData,
                            [fontName]: {
                                fallbacks:
                                    (_fallbackMap$get2 = fallbackMap.get(fontName)) !== null &&
                                        _fallbackMap$get2 !== void 0
                                        ? _fallbackMap$get2
                                        : [],
                                fontName,
                                src: srcObj,
                                variants
                            }
                        };
                    }
                });
                return elementFontData;
            })();
            return value;
        };
    };
    function tidyFontName(font) {
        const trimmed = font.replace(/^\s*['"]([^'"]*)['"]\s*$/, "$1").trim();
        return capitalizeFirstLetters(trimmed);
    }
    function capitalizeFirstLetters(font) {
        return font.replace(/(^\w{1})|(\s+\w{1})/g, (letter) =>
            letter.toUpperCase()
        );
    }
    function joinBaseUrl(s, parentPath) {
        try {
            return new URL(s, parentPath).href;
        } catch (error) {
            console.log(`could not join url ${s} ${parentPath}`);
            return s;
        }
    }
    function getAllNodes() {
        const tagNames = [
            "p",
            "span",
            "h1",
            "h2",
            "h3",
            "h4",
            "h5",
            "a",
            "button",
            "strong",
            "body"
        ];
        return tagNames
            .map((t) => {
                const elements = window.document.getElementsByTagName(t);
                return Array.from(elements);
            })
            .flat();
    }
    const getParentPath = (url) => url;
    const elements = getAllNodes();
    const getElementFontData = initGetElementFontData();
    const fontNameSet = new Set();
    const fontMap = elements.reduce((map, element) => {
        const elementName = element.tagName.toLowerCase();
        const mergedElementFontData = ((_map$get) => {
            let mergedData = {};
            const fontData = getElementFontData(element);
            const currentFontData =
                (_map$get = map.get(elementName)) !== null && _map$get !== void 0
                    ? _map$get
                    : {};
            for (const fontName in fontData) {
                fontNameSet.add(fontName);
                if (fontName in currentFontData) {
                    var _currentFontData$font,
                        _fontData$fontName,
                        _currentFontData$font2,
                        _fontData$fontName2;
                    mergedData = {
                        ...mergedData,
                        [fontName]: {
                            ...currentFontData[fontName],
                            fontName,
                            src: {
                                ...((_currentFontData$font = currentFontData[fontName]) ===
                                    null || _currentFontData$font === void 0
                                    ? void 0
                                    : _currentFontData$font.src),
                                ...((_fontData$fontName = fontData[fontName]) === null ||
                                    _fontData$fontName === void 0
                                    ? void 0
                                    : _fontData$fontName.src)
                            },
                            variants: [
                                ...((_currentFontData$font2 = currentFontData[fontName]) ===
                                    null || _currentFontData$font2 === void 0
                                    ? void 0
                                    : _currentFontData$font2.variants),
                                ...((_fontData$fontName2 = fontData[fontName]) === null ||
                                    _fontData$fontName2 === void 0
                                    ? void 0
                                    : _fontData$fontName2.variants)
                            ]
                        }
                    };
                } else {
                    mergedData = {
                        ...mergedData,
                        [fontName]: fontData[fontName]
                    };
                }
            }
            mergedData = {
                ...currentFontData,
                ...mergedData
            };
            for (const fontName in mergedData) {
                mergedData = {
                    ...mergedData,
                    [fontName]: {
                        ...mergedData[fontName],
                        fallbacks: Array.from(new Set(mergedData[fontName].fallbacks)),
                        variants: Array.from(
                            new Set(
                                mergedData[fontName].variants.map(convertFontVariantToString)
                            )
                        ).map(convertStringToFontVariant)
                    }
                };
            }
            return mergedData;
        })();
        map.set(elementName, mergedElementFontData);
        return map;
    }, new Map());
    return {
        fontInfo: Object.fromEntries(fontMap),
        count: fontNameSet.size
    };
};
// https://cdn.jsdelivr.net/gh/scroobius-pip/fontofweb/frontend-v2-cloudflare/crawler.js