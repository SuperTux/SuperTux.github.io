<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!--
    "Interesting" templates. Templates that match, have high
    priority, and output something meaningful.
  -->
  <xsl:template match="tux-include">
    <xsl:apply-templates select="document(text())"/>
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
