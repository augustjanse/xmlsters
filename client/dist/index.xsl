<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="report">
        <html>
            <head>
                <META http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <link href="http://www.csc.kth.sep/~bjornh/2D1517/kthstandard.mac.css" type="text/css"
                      rel="stylesheet"/>
                <title>
                    <xsl:value-of select="head/title"/>
                </title>
            </head>
            <body>
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

