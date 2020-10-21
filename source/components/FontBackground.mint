component FontBackground {
  property children : Array(Html) = []
  property disable = false

  style container {
    background-color: transparent;
    height: 100%;

    /* width: 100%; */
    padding: 24px;
    overflow: hidden;

    position: relative;
  }

  style font (top : Number, left : Number) {
    position: absolute;
    top: "#{top}%";
    left: "#{left}%";
    z-index: 1;
    transition: .3s;
    opacity: .09;

    &:hover {
      opacity: .08;
    }
  }

  style inner {
    /* max-width: 540px; */
  }

  get background {
    if (!disable) {
      <div>
        <div::font(80, 10)>
          <{ @svg(../../assets/svg/majesti.svg) }>
        </div>

        <div::font(40, 5)>
          <{ @svg(../../assets/svg/segoe_ui.svg) }>
        </div>

        <div::font(55, 50)>
          <{ @svg(../../assets/svg/roboto.svg) }>
        </div>

        <div::font(55, 15)>
          <{ @svg(../../assets/svg/opensans.svg) }>
        </div>
      </div>
    } else {
      Html.empty()
    }
  }

  fun render {
    <div::container>
      <div::inner>
        <{ children }>
        <{ background }>
      </div>
    </div>
  }
}
