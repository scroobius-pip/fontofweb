component Logo {
  style logo {
    height: 1.2em;
    cursor: pointer;

    @media (max-width: 750px) {
      margin: auto;
    }
  }

  fun render {
    <a::logo
      onClick={() { Navigation.goTo(Page::Landing) }}
      href="/">

      <{ @svg(../../assets/svg/logo.svg) }>

    </a>
  }
}
