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

                <link href="http://www.csc.kth.sep/~bjornh/2D1517/kthstandard.mac.css" type="text/css"
                      rel="stylesheet"/>

                <!-- Bootstrap -->
                <link rel="stylesheet" href="../node_modules/bootstrap/dist/css/bootstrap.css"/>
                <script src="../node_modules/jquery/dist/jquery.js"/>
                <script src="../node_modules/popper.js/dist/umd/popper.js"/>
                <script src="../node_modules/bootstrap/dist/js/bootstrap.js"/>

                <!-- Custom files -->
                <link rel="stylesheet" type="text/css" href="../src/index.css"/>
                <script src="../src/index.js"/>
            </head>
            <body>
                <div class="container">
                    <!-- https://stackoverflow.com/a/21779432/1729441 -->
                    <!-- Hack for for loops in XPath 1.0 -->
                    <xsl:for-each select="document('')/descendant::node()[position() &lt;= 42]">
                        <!-- position() will mean something else if called in the expression,
                        so save it now -->
                        <xsl:variable name="pos" select="position()"/>

                        <xsl:if test="$pos = 1 or $pos = 6 or $pos = 11 or $pos = 17 or $pos = 23 or $pos = 33">
                            <xsl:text disable-output-escaping="yes">&lt;div class="row no-gutters"&gt;</xsl:text>
                        </xsl:if>


                        <xsl:if test="$pos = 5 or $pos = 10 or $pos = 16 or $pos = 22 or $pos = 32 or $pos = 42">
                            <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
                        </xsl:if>

                        <xsl:apply-templates select="//body/release[@placement=$pos]">
                        </xsl:apply-templates>
                    </xsl:for-each>
                </div>
                <h1>
                    <xsl:value-of select="head/title"/>
                </h1>
                <p>
                    Authors:
                    <xsl:apply-templates select="head/authors/author"/>
                </p>
                <p>
                    Keywords:
                    <xsl:apply-templates select="head/keywords/keyword"/>
                </p>
                <p>
                    <xsl:apply-templates select="body"/>
                </p>

                <xsl:apply-templates select="body" mode="print"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="author|keyword">
        <xsl:apply-templates/>
        <xsl:if test="position()!=last()">,
        </xsl:if>
    </xsl:template>

    <xsl:template match="h1">
        <xsl:value-of select="position()"/>.
        <a href="#{generate-id()}">
            <xsl:value-of select="@title"/>
        </a>
        <br/>
        <xsl:apply-templates select="h2"/>
    </xsl:template>

    <xsl:template match="h2">
        <xsl:value-of select="count(../preceding-sibling::h1) + 1"/>.<xsl:value-of select="position()"/>.

        <a href="#{generate-id()}">
            <xsl:value-of select="@title"/>
        </a>
        <br/>
        <xsl:apply-templates select="h3"/>
    </xsl:template>

    <xsl:template match="h3">
        <xsl:value-of select="count(../../preceding-sibling::h1) + 1"/>.<xsl:value-of
            select="count(../preceding-sibling::h2) + 1"/>.<xsl:value-of select="position()"/>.

        <a href="#{generate-id()}">
            <xsl:value-of select="@title"/>
        </a>
        <br/>
    </xsl:template>

    <xsl:template match="h1" mode="print">
        <a name="{generate-id()}"/>
        <h2>
            <xsl:value-of select="position()"/>.
            <xsl:value-of select="@title"/>
        </h2>
        <xsl:apply-templates select="p"/>
        <xsl:apply-templates select="h2" mode="print"/>
    </xsl:template>

    <xsl:template match="h2" mode="print">
        <a name="{generate-id()}"/>
        <h3>
            <xsl:value-of select="count(../preceding-sibling::h1) + 1"/>.<xsl:value-of select="position()"/>.
            <xsl:value-of select="@title"/>
        </h3>
        <xsl:apply-templates select="p"/>
        <xsl:apply-templates select="h3" mode="print"/>
    </xsl:template>

    <xsl:template match="h3" mode="print">
        <a name="{generate-id()}"/>
        <h4>
            <xsl:value-of select="count(../../preceding-sibling::h1) + 1"/>.<xsl:value-of
                select="count(../preceding-sibling::h2) + 1"/>.<xsl:value-of select="position()"/>.
            <xsl:value-of select="@title"/>
        </h4>
        <xsl:apply-templates select="p"/>
    </xsl:template>

    <xsl:template match="p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
</xsl:stylesheet>

