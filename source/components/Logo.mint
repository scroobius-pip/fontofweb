component Logo {
  style logo {
    height: 1.6em;
    cursor: pointer;
  }

  fun render {
    <a::logo
      onClick={() { Navigation.goTo(Page::Landing) }}
      href="/">

      <{ @svg(../../assets/svg/logo.svg) }>

    </a>
  }
}
