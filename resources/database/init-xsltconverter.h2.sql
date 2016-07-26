INSERT INTO `xsltconverter` (`creation_time`, `description`, `visibility`, `name`, `stylesheet`, `owner_name`)
VALUES
(0,'Conversion of the TEI (Text Encoding Initiative) format to HTML, for further processing with e-Services.',1,'tei2temp-html','<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="tei xs"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output method="html" indent="yes"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>dummy title</title>
            </head>
            <body>
                <div id="xyz1xyz">
                    <xsl:for-each select="//tei:text/tei:body//tei:p">
                        <xsl:variable name="number">n<xsl:number level="any"/></xsl:variable>
                        <p id="{$number}">
                            <xsl:apply-templates mode="renameElem"/>
                        </p>
                    </xsl:for-each>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template mode="renameElem" match="*">
        <xsl:variable name="attributeValuePairs">
            <xsl:for-each select="@*">
                <xsl:text>@@@delim@@@name:</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>@@@value:</xsl:text>
                <xsl:value-of select="."/>
                <xsl:if test="position() = last()">
                    <xsl:text>@@@delim@@@</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <span xmlns="http://www.w3.org/1999/xhtml" title="{$attributeValuePairs}"
            class="{concat(\''convert-\'',name())}">
            <xsl:apply-templates mode="renameElem"/>
        </span>
    </xsl:template>
</xsl:stylesheet>','admin'),
(0,'Conversion of the input to identical output. Can be used e.g. to transform HTML5 to XHTML5.',1,'identity-transformation','<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"></xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>','admin'),
(0,'A stylesheet that uses XSLT 3.0 functionality.',1,'xslt-30-test','<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"  xmlns:fn="http://www.w3.org/2005/xpath-functions"
    version="3.0">
    <xsl:variable name="input"> &lt;its:locQualityIssues xml:id="lq1" xmlns:its="http://www.w3.org/2005/11/its"&gt;
        &lt;its:locQualityIssue
        locQualityIssueType="misspelling"
        locQualityIssueComment="\''c\''es\'' is unknown. Could be \''c\''est\''"
        locQualityIssueSeverity="50"/&gt;
        &lt;its:locQualityIssue
        locQualityIssueType="typographical"
        locQualityIssueComment="Sentence without capitalization"
        locQualityIssueSeverity="30"/&gt;
        &lt;/its:locQualityIssues&gt;</xsl:variable>
    <xsl:template match="/">
        <xsl:value-of select="count(fn:parse-xml($input)//*)"></xsl:value-of>
    </xsl:template>
</xsl:stylesheet>','admin'),
(0,'Conversion of XLIFF 2.0 to HTML, for further processing with e-Services.',1,'xliff20-to-html','<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xlf xs"
    xmlns:xlf="urn:oasis:names:tc:xliff:document:2.0" version="1.0" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output method="html" indent="yes"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>dummy title</title>
            </head>
            <body>
                <div id="xyz1xyz">
                    <xsl:for-each select="//xlf:source">
                        <xsl:variable name="number">n<xsl:number level="any"/></xsl:variable>
                        <p id="{$number}">
                            <xsl:apply-templates mode="renameElem"/>
                        </p>
                    </xsl:for-each>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template mode="renameElem" match="*">
        <xsl:variable name="attributeValuePairs">
            <xsl:for-each select="@*">
                <xsl:text>@@@delim@@@name:</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>@@@value:</xsl:text>
                <xsl:value-of select="."/>
                <xsl:if test="position() = last()">
                    <xsl:text>@@@delim@@@</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <span xmlns="http://www.w3.org/1999/xhtml" title="{$attributeValuePairs}"
            class="{concat(\''convert - \'', name())}">
            <xsl:apply-templates mode="renameElem"/>
        </span>
    </xsl:template>
</xsl:stylesheet>','admin'),
(0,'Stylesheet with global parameter. The parameter can be set while calling the stylesheet.',1,'xslt-with-param','<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:param name="myparam">set internally</xsl:param>
    <xsl:template match="/">
        <xsl:value-of select="$myparam"/>
    </xsl:template>
</xsl:stylesheet>','admin'),
(0,'Conversion of HTML to XLIFF 2.0. The stylesheet currently processes only e-Entity output.',1,'html-to-xliff20','<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:itsm="urn:oasis:names:tc:xliff:itsm:2.1"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs h xlf fn"
    xmlns:xlf="urn:oasis:names:tc:xliff:document:2.0" version="3.0" xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns="urn:oasis:names:tc:xliff:document:2.0" >
    <xsl:output method="xml"/>
    <xsl:variable name="originalInputDoc">
        <xsl:copy-of select="fn:parse-xml(//*[local-name()=\''script\''])"></xsl:copy-of>
    </xsl:variable>
    <xsl:variable name="htmlDoc">
        <xsl:copy-of select="/*"/>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:apply-templates select="$originalInputDoc/node()" mode="copy"/>
    </xsl:template>
    <xsl:template match="node() | @*" mode="copy">
        <xsl:copy>
            <xsl:apply-templates select="node()| @*" mode="copy"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="h:anchor" mode="copy">
        <source>
            <xsl:variable name="position">n<xsl:number level="any"/></xsl:variable>
            <xsl:for-each select="$htmlDoc">
                <xsl:apply-templates select="//*[@id=$position]/node()" mode="writeAnnotation"/>
            </xsl:for-each>
        </source>
    </xsl:template>
    <xsl:template match="span[@class[starts-with(., \''convert-\'')]]" mode="writeAnnotation">
        <xsl:element name="{substring-after(@class,\''convert-\'')}">
            <xsl:if test="string-length(@title) > 0">
                <xsl:call-template name="writeAttrs">
                    <xsl:with-param name="attList" select="@title"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:apply-templates mode="writeAnnotation"/>
        </xsl:element>
    </xsl:template>
    <xsl:template mode="writeAnnotation" match="span[@its-ta-ident-ref]">
        <mrk id="{generate-id()}" type="itsm:generic">
            <xsl:attribute name="itsm:taIdentRef">
                <xsl:value-of select="@its-ta-ident-ref"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </mrk>
    </xsl:template>
    <xsl:template name="writeAttrs">
        <xsl:param name="attList"/>
        <xsl:variable name="name"
            select="substring-before(substring-after($attList, \''@@@delim@@@name:\''), \''@@@value:\'')"/>
        <xsl:variable name="value"
            select="substring-before(substring-after($attList, \''@@@value:\''), \''@@@delim@@@\'')"/>
        <xsl:if test="($name)">
            <xsl:attribute name="{$name}">
                <xsl:value-of select="$value"/>
            </xsl:attribute>
            <xsl:variable name="rest">
                <xsl:value-of
                    select="substring($attList, string-length(concat(\''@@@delim@@@name:\'', $name, \''@@@value:\'', $value)) + 1)"
                />
            </xsl:variable>
            <xsl:if test="$rest">
                <xsl:call-template name="writeAttrs">
                    <xsl:with-param name="attList" select="$rest"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>','admin');