
(require 'ox-publish)
(setq org-publish-project-alist
      '(

        ("blog-notes"
	 :base-directory "F:/lzgh.github.io/blog/"
	 :base-extension "org"
	 :publishing-directory "F:/lzgh.github.io/"
	 :recursive t
	 :publishing-function org-html-publish-to-html
	 :headline-levels 5             ; Just the default for this project.
	 :auto-preamble t
	 :section-numbers nil
	 :author "lz"
	 :email "example@test.com"
	 :auto-sitemap t                ; Generate sitemap.org automagically...
	 :sitemap-filename "index.org"  ; ... call it sitemap.org (it's the default)...
	 :sitemap-title "LZGH Blog"         ; ... with title 'Sitemap'.
	 :sitemap-sort-files anti-chronologically
	 :sitemap-file-entry-format "%d %t"
	 :html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"stylesheets/worg.css\"/>"
	 :html-postamble "<p class=\"postamble\">Last Updated %C. Created by %a</p>
		<script>
		var _hmt = _hmt || [];
		(function() {
			 var hm = document.createElement(\"script\");
			 hm.src = \"//hm.baidu.com/hm.js?b61fc41c1bbc2645ac5214b77214e73b\";
			 var s = document.getElementsByTagName(\"script\")[0];
			 s.parentNode.insertBefore(hm, s);
			 })();
		</script>

		<div id=\"disqus_thread\"></div>
		<script type=\"text/javascript\">
		var disqus_shortname = 'lzgh';
		(function() {
			 var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
			 dsq.src = 'https://' + disqus_shortname + '.disqus.com/embed.js';
			 (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
			 })();
		</script>
	     <noscript>Please enable JavaScript to view the <a href=\"https://disqus.com/?ref_noscript\" rel=\"nofollow\">comments powered by 			Disqus.</a></noscript>
		"
	 )
	("blog-static"
	 :base-directory "F:/lzgh.github.io/blog/"
	 :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
	 :publishing-directory "F:/lzgh.github.io/"
	 :recursive t
	 :publishing-function org-publish-attachment
	 )
	("blog" :components ("blog-notes" "blog-static"))


        ))

(provide 'init-ox-publish)
