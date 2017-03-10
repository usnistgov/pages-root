# pages-root
A Repository for the root content of pages.nist.gov
----
This directory contains the Jekyll content for the root of the pages.nist.gov site.

It is based on the Pages-Template repo, and contains information about the purpose
of the site and how it was implemented.  It also contains a plugin to generate a
semi-dynamic index of all repos hosted on pages.nist.gov.  Descriptive information
about those repos is extracted from the html title tag in each repo's index.html.

The list is only semi-dynamic because it will only be updated on a push to this repo
or on a site rebuild.  (pages currently forces a site rebuild for all sites
every four hours.)
