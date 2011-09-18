# include.js

  Include js enables a super simple client side include patten. The goal is to
  let you treat parts of your page as individual assets, like an image, so they
  load over their own http connection giving you http caching control over parts
  of your page.

## running the example app

    git clone git://github.com/deadlyicon/include.js.git
    cd include.js
    (cd example && rackup)

  0. open a new tab in chrome
  0. open the network tab in the developer tools (cmd-opt-i)
  0. go to http://localhost:9292
  0. watch the page load pitifully slowly
  0. load the page again (don't use cmd-r use cmd-l,enter)
  0. watch the page load incredibly fast
