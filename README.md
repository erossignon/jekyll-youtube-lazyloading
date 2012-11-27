jekyll-youtube-lazyloading
==========================

This Jekill/Octopress plugin improves the responsiveness on page that embed many youtube iframe by delaying the iframe creation until the user clicks on the video

## How to use it 

add a ```{% youtube <videoid> %}``` in your markdown page

## Demo 
  
see [this page for a demo](http://erossignon.github.com/blog/2012/11/22/10-awsome-applications-with-raspberry-pi/)


## How to install it ?

1. Add ```youtube.rb``` to your ```plugin``` folder
2. Copy ```_rve.sccs``` to ```/sass/custom```
3. Add ```@import "custom/rve``` to  ```/sass/screen.scss```

## credits

Thanks go to Anders M. Andersen for his [blogpost about responsive embeds](http://amobil.se/2011/11/responsive-embeds/) and to Portway Point for their [Jekyll Youtube Liquid Template Tag Gist](http://www.portwaypoint.co.uk/jekyll-youtube-liquid-template-tag-gist/)

## Edorsement

If you like it feel free to endorse me: [![](http://api.coderwall.com/erossignon/endorsecount.png)](http://coderwall.com/erossignon)
