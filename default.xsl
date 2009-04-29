<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	        xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes" media-type="text/xml"
	      doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	      encoding="ISO-8859-1" />

  <xsl:param name="filename"/>
  <xsl:param name="lastchange"/>
  <xsl:param name="section"/>
  <xsl:param name="basedir" />

  <xsl:template match="node()|@*">
    <xsl:copy><xsl:apply-templates select="@* | node()" /></xsl:copy>
  </xsl:template>

  <xsl:template match="dlink-full">
    <a href="{@href}"><xsl:value-of select="@href" /></a>
  </xsl:template>

  <xsl:template match="page">
    <html>
      <head>
	<title><xsl:value-of select="@title" /></title>
	<link rel="stylesheet" type="text/css" href="{$basedir}default.css" />
	<link rel="icon" href="/images/favicon.png" type="image/png" />
      </head>

      <body>
        <div id="page">
	  <div id="title">
	    <img src="{$basedir}images/title.png" alt="Logo of SuperTux" />
            <xsl:apply-templates select="document('menu.xml')" />  
	  </div>

          <div id="pagebody">
	    <xsl:apply-templates />
          </div>

	  <div id="copyright">
	    Contact via IRC: irc.freenode.net, #supertux<br/>
            Contact via <a href="http://lists.lethargik.org/listinfo.cgi/supertux-devel-lethargik.org">Mailing List</a>: 
            <a href="mailto:supertux-devel@lists.lethargik.org">supertux-devel@lists.lethargik.org</a><br/>
	    Last update: <xsl:value-of select="$lastchange" />
	  </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="section">
    <xsl:if test="@id!=''">
      <xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
    </xsl:if>
    <h2><xsl:value-of select="@title" /></h2>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="subsection">
    <h3><xsl:value-of select="@title" /></h3>
    <xsl:apply-templates />
    <br style="clear: both;" />
  </xsl:template>

  <xsl:template match="subsubsection">
    <div style="padding-left: 1em; clear: both;">
      <h4><xsl:value-of select="@title" /></h4>
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="faq-list">
    <ul>
      <xsl:for-each select="faq/question">
	<li><a href="#faq{generate-id(.)}">
	    <xsl:apply-templates/></a></li>
      </xsl:for-each>
    </ul>
    <hr/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="faq">
    <p></p>
    <table width="100%"  class="question">
      <colgroup width="60%" />
      <tr><td valign="top">
	  <div id="faq{generate-id(question)}">
	    <xsl:apply-templates select="question/node()"/>
	  </div>
	</td>


	<td align="right" valign="top">
	  <small>Last update:<xsl:value-of select="@date"/></small>
	  [<small><a href="#faqtoc">Up</a></small>]
	</td>
      </tr>
    </table>

    <p class="answer"><xsl:apply-templates select="answer/node()"/> </p>
  </xsl:template>

  <xsl:template match="news">
    <xsl:apply-templates select="item"/>
  </xsl:template>

  <xsl:template match="news/item">
    <xsl:if test="position() &lt;= 10">
      <p style="padding: 0em;"><strong><xsl:value-of select="@date" /></strong> - <xsl:apply-templates /></p>
    </xsl:if>
  </xsl:template>

  <xsl:template match="menu">
    <ul class="menu">
      <xsl:apply-templates />
    </ul>
  </xsl:template>

  <xsl:template match="menu/item">
    <xsl:choose>
      <!-- FIXME: Take sections into account -->
      <xsl:when test="@section=$filename">
	<li class="active"><a class="active"><xsl:apply-templates /></a></li>
      </xsl:when>
      <xsl:otherwise>
	<xsl:choose>
	  <xsl:when test="@section='sfnet' or $section='.'">
	    <li><a href="{@file}"><xsl:apply-templates /></a></li>
	  </xsl:when>
	  <xsl:otherwise>
	    <li><a href="../{@file}"><xsl:apply-templates /></a></li>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="picture">
    <table border="0">
      <tr>
	<td valign="top">
	  <img src="{@file}" alt="{@alt}" />
	</td>
	<td valign="top">
	  <xsl:apply-templates />
	</td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="arrow">&#8594;</xsl:template>

  <xsl:template match="screenshot">
    <a href="{@file}.jpg"><img class="screenshot" alt="{@file}" src="{@file}_small.jpg" title="{.}"/></a>
  </xsl:template>

  <xsl:template match="pngscreenshot">
    <a href="{@file}.png"><img class="screenshot" alt="{@file}" src="{@file}_small.jpg" title="{.}"/></a>
  </xsl:template>

  <xsl:template match="author">
    <xsl:choose>
      <xsl:when test="@type='oneliner'">
	<b><xsl:value-of select="@name" /> - <xsl:apply-templates /></b><br />
      </xsl:when>
      <xsl:otherwise>
	<b><xsl:value-of select="@name" /></b><br />
	<xsl:apply-templates /><br />
	<br />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
