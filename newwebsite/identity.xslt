<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="*">
    <xsl:call-template name="identity"/>
  </xsl:template>
  <xsl:template match="@*">
    <xsl:call-template name="identity"/>
  </xsl:template>
  <xsl:template match="text()">
    <xsl:call-template name="identity"/>
  </xsl:template>
  <xsl:template match="processing-instruction()">
    <!-- no output -->
  </xsl:template>
  <xsl:template match="comment()">
    <xsl:call-template name="identity"/>
  </xsl:template>

  <xsl:template name="identity">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
