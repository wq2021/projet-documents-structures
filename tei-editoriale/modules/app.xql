xquery version "3.1";

module namespace app="http://localhost:8080/exist/apps/projet/templates";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://localhost:8080/exist/apps/projet/config" at "config.xqm";

(:~
 : This is a sample templating function. It will be called by the templating module if
 : it encounters an HTML element with an attribute: data-template="app:test" or class="app:test" (deprecated). 
 : The function has to take 2 default parameters. Additional parameters are automatically mapped to
 : any matching request or function parameter.
 : 
 : @param $node the HTML node with the attribute which triggered this call
 : @param $model a map containing arbitrary data - used to pass information between template calls
 :)

declare function app:test($node as node(), $model as map(*)) {
    <!--
    <p>Dummy template output generated by function app:test at {current-dateTime()}. The templating
        function was triggered by the data-template attribute <code>data-template="app:test"</code>.</p>
        -->
};