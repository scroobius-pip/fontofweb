record FontData {

}

component FontCard {
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

  style container {
    margin-bottom: 10px;
    color: #{Color:WHITE};
    padding: 2em;
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

  fun render {
    <div::container>
      <div::elementcontainer>
        <div::element>"<span />"</div>
      </div>

      <Margin value="40px"/>

      <div>
        <div::font>
          <div>
            <span style="margin-right:.2em;">
              "Roboto"
            </span>

            <span::download style="cursor:pointer;"/>
          </div>
        </div>

        <div>
          <FontVariant
            weight="400"
            lineHeight="20px"
            size="50px"/>

          <FontVariant
            weight="400"
            lineHeight="25px"
            size="30px"/>
        </div>

        <div>
          <label>"Fallbacks"</label>
          <h3>"Consolas, Arial, san-serif"</h3>
        </div>
      </div>
    </div>
  }
}

component FontVariant {
  property weight : String
  property lineHeight : String
  property size : String

  style container {
    display: flex;
    margin-bottom: 25px;

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
        <h3>"600"</h3>
      </div>

      <div::mr>
        <label>"Line Height"</label>
        <h3>"20px"</h3>
      </div>

      <div>
        <label>"Size"</label>
        <h3>"50px"</h3>
      </div>
    </div>
  }
}
