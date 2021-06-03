component FontSummaryCard {
  property fontData : FontData

  style container {
    /* margin-bottom: .5px; */
    color: #{Color:PRIMARY};
    padding: .5em 2em .5em 2em;

    /*
    padding-bottom: 10px;
       padding-top: 10px;
    */
    background-color: #{Color:WHITE};
    transition: .3s;

    &:first-child {
      padding-top: 2em;
    }

    ,
    &:last-child {
      padding-bottom: 2em;
    }

    /*
    &:hover {
         background-color: #FFC8C6;
         color: #{Color:PRIMARY};
       }
    */
    label {
      font-size: .9em;
      font-weight: 600;
    }

    /* background-opacity: 0.5; */
  }

  style font {
    font-size: 1.4em;
    font-weight: 600;
  }

  style family (family : String, weight : String) {
    font-family: '#{family}', invisible;
    font-weight: #{weight};
  }

  style show (value : Bool) {
    if (value) {
      display: none;
    }
  }

  style preview {
    font-size: 3.5em;
  }

  style download {
    /* margin-left: 1em; */
    >* {
      margin-right: .3em;
    }

    a {
      text-decoration: none;
      color: inherit;
      text-transform: uppercase;
    }

    /* font-size: .5em; */
  }

  fun render {
    <div::container>
      <div>
        <div::font>
          <div>
            <span style="margin-right:.2em;">
              <{ fontData.fontName }>
            </span>

            <style>
              <{ FontCardUtils.renderFontStyle(fontData.fontName, FontCardUtils.getFontSrc(fontData)) }>
            </style>
          </div>
        </div>

        <div::show(Map.isEmpty(fontData.src))>
          <Margin/>

          <p::preview::family(fontData.fontName, FontCardUtils.getFontWeight(fontData))>"Almost before we knew it, we had left the ground."</p>
          <Margin/>
        </div>

        <div::show(Map.isEmpty(fontData.src))>
          <label>"Download"</label>

          <div::download>
            <{
              fontData.src
              |> Map.map(FontCardUtils.renderFontSrc())
              |> Map.values()
            }>
          </div>
        </div>
      </div>
    </div>
  }
}
