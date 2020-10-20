component Logo {
  style logo {
    width: 100%;
    height: 1.8em;
  }

  fun render {
    <div::logo>
      <{ @svg(../../assets/svg/logo.svg) }>
    </div>
  }
}
