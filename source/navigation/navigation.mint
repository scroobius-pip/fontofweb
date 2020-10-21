enum Page {
  Landing
  Result(String)
}

store Navigation {
  state page : Page = Page::Landing

  fun goTo (page : Page) {
    sequence {
      next { page = page }
    }
  }
}

component Navigator {
  connect Navigation exposing { page }

  get currentPage : Html {
    case (page) {
      Page::Landing => <LandingPage/>
      Page::Result url => <ResultPage initialUrl={url}/>
    }
  }

  fun render {
    <{ currentPage }>
  }
}

routes {
  / {
    Navigation.goTo(Page::Landing)
  }

  /site/:url (url : String) {
    Navigation.goTo(Page::Result(url))
  }
}
