<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exslt="http://exslt.org/common">
  <xsl:output method="html" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!--
    "Interesting" templates. Templates that match, have high
    priority, and output something meaningful.
  -->
  <xsl:template match="tux-include">
    <xsl:apply-templates select="document(text())"/>
  </xsl:template>

  <xsl:template match="tux-head">
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <meta charset="utf-8"/>
      <title>
        <xsl:text>SuperTux - </xsl:text>
        <xsl:value-of select="@title"/>
      </title>
      <link rel="stylesheet" type="text/css" href="default.css"/>
      <link rel="icon" href="/images/favicon.png" type="image/png"/>
    </head>
  </xsl:template>

  <xsl:template match="tux-page">
    <html lang="en-US">
      <xsl:variable name="tmp_title">
        <tux-head title="{@title}"/>
      </xsl:variable>
      <xsl:apply-templates select="exslt:node-set($tmp_title)"/>

      <body>
        <div id="page">
          <xsl:variable name="tmp_header">
            <tux-include>bits/header.xml</tux-include>
          </xsl:variable>
          <xsl:apply-templates select="exslt:node-set($tmp_header)"/>

          <xsl:apply-templates select="node()"/>

          <xsl:variable name="tmp_footer">
            <tux-include>bits/footer.xml</tux-include>
          </xsl:variable>
          <xsl:apply-templates select="exslt:node-set($tmp_footer)"/>
        </div>
      </body>
    </html>
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
</xsl:stylesheet>
