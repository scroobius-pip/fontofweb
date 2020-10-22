component FontCard {
  property elementData : Map(String, FontData)
  property elementName : String

  style elementcontainer {
    display: block;
    margin-top: -2em;
    margin-left: -2em;
  }

  style element {
    line-height: 0px;
    font-weight: 800;
    padding: 1.4em 2em;
    font-size: 1.2em;
    color: #{Color:PRIMARY};
    background-color: #{Color:WHITE};
    display: inline-block;
  }

  style fallbacks (f : Array(String)) {
    if (Array.isEmpty(f)) {
      display: none;
    }

    margin-bottom: 12px;
  }

  style container {
    margin-bottom: 10px;
    color: #{Color:WHITE};
    padding: 2em;

    padding-bottom: 1em;
    background-color: #{Color:TRANSPARENT};
    transition: .3s;

    &:hover {
      background-color: #FFC8C6;
      color: #{Color:PRIMARY};
    }

    label {
      font-size: .9em;
      font-weight: 600;
    }

    /* background-opacity: 0.5; */
  }

  style font {
    font-size: 1.8em;
    font-weight: 600;
  }

  style family (family : String) {
    /* font-family: "#{String.toLowerCase(family)}"; */
  }

  style variants {
    display: flex;
  }

  style download {
    height: 1em;
    width: 1em;

    *:hover {
      fill: #{Color:PRIMARY};
    }
  }

  fun renderFont (fontName : String, fontData : FontData) : Html {
    <div style="margin-bottom:48px;">
      <div::font>
        <div>
          <span::family(fontName) style="margin-right:.2em;">
            <{ fontName }>
          </span>

          <span::download style="cursor:pointer;"/>
        </div>
      </div>

      <div::fallbacks(fontData.fallbacks)>
        <label>"Fallbacks"</label>

        <h3>
          <{
            fontData.fallbacks
            |> String.join(", ")
          }>
        </h3>
      </div>

      <div style="margin-top:24px;">
        <{
          fontData.variants
          |> Array.map(
            (variant : FontVariant) {
              <FontVariant
                weight={variant.weight}
                lineHeight={variant.lineHeight}
                size={variant.size}/>
            })
        }>
      </div>
    </div>
  }

  get renderFontList {
    elementData
    |> Map.map(renderFont)
    |> Map.values()
  }

  fun render {
    <div::container>
      <div::elementcontainer>
        <div::element>"<#{elementName} />"</div>
      </div>

      <Margin value="24px"/>
      <{ renderFontList }>
    </div>
  }
}

component FontVariant {
  property weight : String
  property lineHeight : String
  property size : String

  style container {
    display: flex;
    margin-bottom: 12px;

    label {
      font-size: .9em;
      font-weight: 600;
    }

    h3 {
      font-size: 1.8em;
      line-height: 1em;
    }
  }

  style mr {
    margin-right: 15px;
  }

  fun render {
    <div::container>
      <div::mr>
        <label>"Weight"</label>

        <h3>
          <{ weight }>
        </h3>
      </div>

      <div::mr>
        <label>"Line Height"</label>

        <h3>
          <{ lineHeight }>
        </h3>
      </div>

      <div>
        <label>"Size"</label>

        <h3>
          <{ size }>
        </h3>
      </div>
    </div>
  }
}
