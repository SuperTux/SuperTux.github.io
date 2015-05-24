<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
    exclude-result-prefixes="tux exslt msxsl"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:tux="http://supertux.github.io/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exslt="http://exslt.org/common"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
>
  <xsl:output method="xml" indent="yes"
      encoding="utf-8"
      media-type="application/xhtml+xml"
      doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
  />
  <xsl:strip-space elements="*"/>

  <!--
    "Interesting" templates. Templates that match, have high
    priority, and output something meaningful.
  -->
  <xsl:template match="tux:include">
    <xsl:apply-templates select="document(text())"/>
  </xsl:template>

  <xsl:template match="tux:head">
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <title>
        <xsl:text>SuperTux - </xsl:text>
        <xsl:value-of select="@title"/>
      </title>
      <link rel="stylesheet" type="text/css" href="default.css"/>
      <link rel="icon" href="/images/favicon.png" type="image/png"/>
    </head>
  </xsl:template>

  <xsl:template match="tux:page">
    <html lang="en-US">
      <xsl:variable name="tmp_title">
        <tux:head title="{@title}"/>
      </xsl:variable>
      <xsl:apply-templates select="exslt:node-set($tmp_title)"/>

      <body>
        <div id="page">
          <xsl:variable name="tmp_header">
            <tux:include>bits/header.xml</tux:include>
          </xsl:variable>
          <xsl:apply-templates select="exslt:node-set($tmp_header)"/>

          <xsl:apply-templates select="node()"/>

          <xsl:variable name="tmp_footer">
            <tux:include>bits/footer.xml</tux:include>
          </xsl:variable>
          <xsl:apply-templates select="exslt:node-set($tmp_footer)"/>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="tux:screenshots">
    <div>
      <xsl:for-each select="node()">
        <xsl:if test="position() != 1 and position() mod ../@cols = 1">
          <br/>
        </xsl:if>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </div>
  </xsl:template>
  <xsl:template match="tux:screenshot" name="screenshot">
    <a href="{@large}"><img class="screenshot" alt="{@large}" src="{@small}" width="{../@thumb-width}" height="{../@thumb-height}"/></a>
  </xsl:template>

  <xsl:template match="tux:summarize">
    <xsl:apply-templates select="document(text())//*[@bless]"/>
  </xsl:template>

  <xsl:template match="tux:downloads">
    <xsl:apply-templates select="node()"/>
  </xsl:template>
  <xsl:template match="tux:download-os">
    <div style="padding-left: 1em; clear: both;">
      <h4><xsl:value-of select="@os"/></h4>
      <ul>
        <xsl:apply-templates select="node()"/>
      </ul>
    </div>
  </xsl:template>
  <xsl:template match="tux:download">
    <li>
      <a href="{../../@dir}{@file}">
        <xsl:value-of select="@file"/>
        <xsl:if test="@comment">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="@comment"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </a>
    </li>
  </xsl:template>

  <xsl:template match="tux:newsfeed">
    <xsl:apply-templates select="node()"/>
  </xsl:template>
  <xsl:template match="tux:news">
    <br/>
    <hr/>
    <div class="datestamp">
      <p><xsl:value-of select="@date"/></p>
    </div>
    <br/>
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <xsl:template match="tux:credits">
    <div>
      <h2><xsl:value-of select="@for"/></h2>
      <xsl:apply-templates select="*"/>
    </div>
    <br/>
  </xsl:template>
  <xsl:template match="tux:author">
    <p>
      <b><xsl:value-of select="@who"/></b>
      <br/>
      <xsl:value-of select="@what"/>
    </p>
  </xsl:template>
  <xsl:template match="tux:music">
    <p>"<xsl:value-of select="@what"/>"
      <br/>
      by <b><xsl:value-of select="@who"/></b>
      <xsl:if test="@remix">
        <br/>
        remixed by <b><xsl:value-of select="@remix"/></b>
      </xsl:if>
    </p>
  </xsl:template>
  <xsl:template match="tux:sound">
    <p>
      <b><xsl:value-of select="@who"/></b>
    </p>
  </xsl:template>
  <xsl:template match="tux:voice">
    <p>
      <b><xsl:value-of select="@who"/></b>
      <br/>
      as <b><xsl:value-of select="@what"/></b>
    </p>
  </xsl:template>
  <xsl:template match="tux:translation">
    <p>
      <b><xsl:value-of select="@who"/></b>
      <br/>
      (<xsl:value-of select="@what"/>)
    </p>
  </xsl:template>
  <xsl:template match="tux:special">
    <p>
      <b><xsl:value-of select="@who"/></b>
      <br/>
      <xsl:value-of select="@what"/>
    </p>
  </xsl:template>

  <!--
    Use identity transform at low priority.
    Note that the default priority, if unspecified,
    is between -0.5 and 0.5 depending on the pattern.
  -->
  <xsl:template match="*" priority="-100">
    <xsl:call-template name="identity"/>
  </xsl:template>
  <xsl:template match="@*" priority="-100">
    <xsl:call-template name="identity"/>
  </xsl:template>
  <xsl:template match="text()" priority="-100">
    <xsl:call-template name="identity"/>
  </xsl:template>
  <xsl:template match="processing-instruction()" priority="-100">
    <!-- no output -->
  </xsl:template>
  <xsl:template match="comment()" priority="-100">
    <xsl:call-template name="identity"/>
  </xsl:template>

  <!--
    Library templates. These do not match anything,
    they must be called explicitly.
  -->
  <xsl:template name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!--
    Workaround for Internet Explorer. Sigh.
  -->
  <msxsl:script language="JScript" implements-prefix="exslt">
    this['node-set'] =  function (x) { return x; }
  </msxsl:script>
  <xsl:template match="xhtml:div[@class='no-xslt']">
    <!-- Remove this. -->
  </xsl:template>
</xsl:stylesheet>
