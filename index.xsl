<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="chart">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>

                <title>xmlsters</title>

                <!-- Bootstrap -->
                <link rel="stylesheet" href="node_modules/bootstrap/dist/css/bootstrap.css"/>
                <script src="node_modules/jquery/dist/jquery.js"/>
                <script src="node_modules/popper.js/dist/umd/popper.js"/>
                <script src="node_modules/bootstrap/dist/js/bootstrap.js"/>

                <!-- Custom files -->
                <link rel="stylesheet" type="text/css" href="index.css"/>
                <script src="index.js"/>
            </head>
            <body>
                <div class="container">
                    <!-- https://stackoverflow.com/a/21779432/1729441 -->
                    <!-- Hack for for loops in XPath 1.0 -->
                    <xsl:variable name="dot" select="."/> <!-- Save context from outside loop -->
                    <!-- Relies on the fact that XSL has at least 42 elements:  makes for some weird bugs -->
                    <xsl:for-each select="document('')/descendant::node()[position() &lt;= 42]">
                        <xsl:variable name="pos" select="position()"/>

                        <xsl:if test="$pos = 1 or $pos = 6 or $pos = 11 or $pos = 17 or $pos = 23 or $pos = 33">
                            <xsl:text disable-output-escaping="yes">&lt;div class="row no-gutters"&gt;</xsl:text>
                        </xsl:if>

                        <div class="col m-1">
                            <img data-mbid="{$dot/body/release[@placement=$pos]}" draggable="true"
                                 ondragstart="drag(event)" ondrop="drop(event)"
                                 ondragover="allowDrop(event)" src="FFFFFF-1.png"/>
                        </div>

                        <xsl:if test="$pos = 5 or $pos = 10 or $pos = 16 or $pos = 22 or $pos = 32 or $pos = 42">
                            <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
                        </xsl:if>
                    </xsl:for-each>

                    <!-- Static form and tray -->
                    <form>
                        <input type="text" name="mbid" id="mbid_box"/>
                        <input type="submit" name="Submit" value="Submit"/>
                    </form>

                    <div id="tray" class="container">
                        <div class="row no-gutters">
                            <div class="col m-1">
                                <img data-mbid="" draggable="true" ondragstart="drag(event)" ondrop="drop(event)"
                                     ondragover="allowDrop(event)" src="FFFFFF-1.png"/>
                            </div>
                            <div class="col m-1">
                                <img data-mbid="" draggable="true" ondragstart="drag(event)" ondrop="drop(event)"
                                     ondragover="allowDrop(event)" src="FFFFFF-1.png"/>
                            </div>
                            <div class="col m-1">
                                <img data-mbid="" draggable="true" ondragstart="drag(event)" ondrop="drop(event)"
                                     ondragover="allowDrop(event)" src="FFFFFF-1.png"/>
                            </div>
                            <div class="col m-1">
                                <img data-mbid="" draggable="true" ondragstart="drag(event)" ondrop="drop(event)"
                                     ondragover="allowDrop(event)" src="FFFFFF-1.png"/>
                            </div>
                            <div class="col m-1">
                                <img data-mbid="" draggable="true" ondragstart="drag(event)" ondrop="drop(event)"
                                     ondragover="allowDrop(event)" src="FFFFFF-1.png"/>
                            </div>
                        </div>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
