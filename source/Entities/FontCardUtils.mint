module FontCardUtils {
  fun addCors (url : String) : String {
    "https://cors-anywhere.herokuapp.com/" + url
  }

  fun getFontSrc (fontData : FontData) : String {
    fontData.src
    |> Map.map(
      (format : String, url : String) : String {
        "url('#{addCors(url)}') format('#{format}')"
      })
    |> Map.values()
    |> String.join(", ")
  }

  fun renderFontStyle (family : String, fontSrc : String) : String {
    "
       @font-face {
         font-family: '#{family}';
         src: #{fontSrc};
         font-display: block;
       }
          
    "
  }

  fun renderFontSrc (srcName : String, src : String) : Html {
    <a href={src}>
      <{ srcName }>
    </a>
  }

  fun getFontWeight (fontData : FontData) : String {
    Array.firstWithDefault(FontVariant("", "", ""), fontData.variants).weight
  }
}
