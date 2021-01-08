xquery version "3.0";
(:~
 : A set of helper functions to access the application context from
 : within a module.
 :)

module namespace config = "http://localhost:8080/exist/apps/projet/config";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace templates="http://exist-db.org/xquery/templates";

declare namespace repo="http://exist-db.org/xquery/repo";
declare namespace expath="http://expath.org/ns/pkg";

(: 
    Determine the application root collection from the current module load path.
:)
declare variable $config:app-root := 
    let $rawPath := system:get-module-load-path()
    let $modulePath :=
        (: strip the xmldb: part :)
        if (starts-with($rawPath, "xmldb:exist://")) then
            if (starts-with($rawPath, "xmldb:exist://embedded-eXist-server")) then
                substring($rawPath, 36)
            else
                substring($rawPath, 15)
        else
            $rawPath
    return
        substring-before($modulePath, "/modules")
;

declare variable $config:data-root := $config:app-root || "/data";

declare variable $config:repo-descriptor := doc(concat($config:app-root, "/repo.xml"))/repo:meta;

declare variable $config:expath-descriptor := doc(concat($config:app-root, "/expath-pkg.xml"))/expath:package;

(:~
 : Resolve the given path using the current application context.
 : If the app resides in the file system,
 :)
declare function config:resolve($relPath as xs:string) {
    if (starts-with($config:app-root, "/db")) then
        doc(concat($config:app-root, "/", $relPath))
    else
        doc(concat("file://", $config:app-root, "/", $relPath))
};

(:~
 : Returns the repo.xml descriptor for the current application.
 :)
declare function config:repo-descriptor() as element(repo:meta) {
    $config:repo-descriptor
};

(:~
 : Returns the expath-pkg.xml descriptor for the current application.
 :)
declare function config:expath-descriptor() as element(expath:package) {
    $config:expath-descriptor
};

declare %templates:wrap function config:app-title($node as node(), $model as map(*)) as text() {
    $config:expath-descriptor/expath:title/text()
};

declare function config:app-meta($node as node(), $model as map(*)) as element()* {
    <meta xmlns="http://www.w3.org/1999/xhtml" name="description" content="{$config:repo-descriptor/repo:description/text()}"/>,
    for $author in $config:repo-descriptor/repo:author
    return
        <meta xmlns="http://www.w3.org/1999/xhtml" name="creator" content="{$author/text()}"/>
};

(:~
 : For debugging: generates a table showing all properties defined
 : in the application descriptors.
 :)
declare function config:app-info($node as node(), $model as map(*)) {
    let $expath := config:expath-descriptor()
    let $repo := config:repo-descriptor()
    return
        <table class="app-info">
            <tr>
                <td>app collection:</td>
                <td>{$config:app-root}</td>
            </tr>
            {
                for $attr in ($expath/@*, $expath/*, $repo/*)
                return
                    <tr>
                        <td>{node-name($attr)}:</td>
                        <td>{$attr/string()}</td>
                    </tr>
            }
            <tr>
                <td>Controller:</td>
                <td>{ request:get-attribute("$exist:controller") }</td>
            </tr>
        </table>
};

(: ajouter la fonction qui permet de la recherche plein texte :)

declare function config:recherche-annee-creation($node as node(), $model as map(*), $annee as xs:string?){
        
        if ($annee)
        then
            
        let $repertoire := collection(concat($config:app-root, "/data"))
        for $fichier in $repertoire
        let $contenu := $fichier//tei:body//tei:p/text()
        let $titre := $fichier//tei:titleStmt/tei:title/text()
        let $auteur := $fichier//tei:titleStmt/tei:author/text()
        let $date_publication := $fichier//tei:publicationStmt/tei:date/text()        
        let $annee_creation := $fichier//tei:profileDesc/tei:creation/tei:date/text()
        
        
        return 
            if ($annee = $annee_creation) 
            then 
                <div>
                    <br></br>
                    <p>Information des métadonnées:</p>
                    <table border='1'>
                    <tr>
                        <th> Titre de document </th>
                        <th> Auteur </th>
                        <th> Date de la publication </th>
                        <th> Année de création </th>
                    </tr>
                    
                    <tr>
                        <td> {$titre[1]} </td>
                        <td> {$auteur[1]} </td>
                        <td> {$date_publication[1]} </td>
                        <td> {$annee_creation[1]} </td>
                    </tr>
                    </table>
                    <br></br>
                    <p>Texte complet du document:</p>
                    <table border='1'>
                    <tr><td>{$contenu}</td></tr>
                    
                    </table>
                </div>
            else ()
        else()
};

declare function config:recherche-publication($node as node(), $model as map(*), $entree as xs:string?){
        
        if ($entree)
        then
            
        let $repertoire := collection(concat($config:app-root, "/data"))
        for $fichier in $repertoire
        let $contenu := $fichier//tei:body//tei:p/text()
        let $titre := $fichier//tei:titleStmt/tei:title/text()
        let $auteur := $fichier//tei:titleStmt/tei:author/text()
        let $date_publication := $fichier//tei:publicationStmt/tei:date/text()
        let $annee_creation := $fichier//tei:profileDesc/tei:creation/tei:date/text()
        
        
        return 
            if ($entree = substring-after(substring-after($date_publication,'/'),'/')) 
            then 
                <div>
                    <br></br>
                    <p>Information des métadonnées:</p>
                    <table border='1'>
                    <tr>
                        <th> Titre de document </th>
                        <th> Auteur </th>
                        <th> Date de la Publication </th>
                        <th> Année de création </th>
                    </tr>
                    
                    <tr>
                        <td> {$titre[1]} </td>
                        <td> {$auteur[1]} </td>
                        <td> {$date_publication[1]} </td>
                        <td> {$annee_creation[1]} </td>
                    </tr>
                    </table>
                    <br></br>
                    <p>Texte complet du document:</p>
                    <table border='1'>
                    <tr><td>{$contenu}</td></tr>
                    
                    </table>
                </div>
            else ()
        else()
};


declare function config:recherche-plein-texte($node as node(), $model as map(*), $cle as xs:string?, $aut as xs:string?) {

    let $repertoire := collection(concat($config:app-root, "/data"))
    for $fichier in $repertoire
    let $titre := $fichier//tei:titleStmt/tei:title/text()
    let $auteur := $fichier//tei:titleStmt/tei:author/text()
    let $date_publication := $fichier//tei:publicationStmt/tei:date/text()
    let $annee_creation := $fichier//tei:profileDesc/tei:creation/tei:date/text()    
    let $contenu := $fichier//tei:text//tei:p
    for $node in $contenu
    let $noeud := $node
    for $match in $noeud[ft:query(., $cle)]
    return
        if ($aut = $auteur)
        then
            <div>
                <br></br>
                <table border='1' >
                <tr>
                    <th> Nom de document </th>
                    <th> Auteur </th>
                    <th> Date de la Publication </th>
                    <th> Année de création </th>
                    <th> Mot-clé </th>
                    <th> Résultat </th>
                </tr>
                <tr>
                    <td> {$titre[1]} </td>
                    <td> {$auteur[1]} </td>
                    <td> {$date_publication[1]} </td>
                    <td> {$annee_creation[1]} </td>
                    <td> {$cle} </td>
                    <td> {$match} </td>
                </tr>
                </table>
            </div> 
        else()
};

declare function config:rendu($node as node(), $model as map(*), $document as xs:string?) {

    for $fichier in collection(concat($config:app-root, "/data"))
    let $titre := $fichier//tei:titleStmt/tei:title/text()
    where $document = $titre
    return
        transform:transform($fichier, doc("/db/apps/projet/resources/rendu.xsl"), ())
};
