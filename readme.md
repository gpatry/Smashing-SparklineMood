# Samshing-Sparklinemood

This widget is a merge of the Nicolas Deverge's Teammood widget [Teammood.coffee](https://gist.github.com/ndeverge/5356317f593b3b09bb58) and the [Sparkline](https://gist.github.com/jorgemorgado/26068a72540619a4d4ec) widget
This widget show the average moods for a team and a sparkline whith the last 15 days average.

## Description

Simple [Dashing](http://shopify.github.com/dashing) widget to display your Teammood average and the average of the day before.

## Usage

To use this widget :
- copy `sparklinemood.html`, `sparklinemood.coffee`, and `sparklinemood.scss` into the `/widgets/sparklinemood` directory.
- copy `sparklinemood.rb` into the `/jobs` directory.
- copy `icomoon.eot`, `icomoon.svg`, `icomoon.ttf` and `icomoon.woff` into the `/assets/fonts` directory
- adapt the `sparklinemood.rb` job to set your team api key

To include the widget in a dashboard, add the following snippet to the dashboard layout file:

    <li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
      <div data-id="sparklinemood" data-view="sparklinemood" data-title="TeamMood"></div>
    </li>

## Preview

![](http://confluence.b.bbg/pages/viewpage.action?pageId=199459240&preview=/199459240/308512098/smashing-widget-sparlinemood.png)
