component FontBackground {
  property children : Array(Html) = []

  style container {
    background-color: transparent;
    height: 100%;
    width: 100%;
    padding: 48px;
    overflow: hidden;

    position: relative;
  }

  style font (top : Number, left : Number) {
    position: absolute;
    top: "#{top}%";
    z-index: 1;

    transition: .3s;
    opacity: .09;

    &:hover {
      opacity: .08;
    }

    left: "#{left}%";
  }

  style inner {
    /* max-width: 540px; */
  }

  fun render {
    <div::container>
      <div::inner>
        <{ children }>

        <div::font(10, 15)>
          <{ @svg(../../assets/svg/majesti.svg) }>
        </div>

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
    </div>
  }
}
