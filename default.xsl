<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:output 
    method="html" 
    indent="yes" 
    doctype-public="-//W3C//DTD HTML 4.01//EN" 
    doctype-system="http://www.w3.org/TR/html4/strict.dtd"
    encoding="ISO-8859-1" />

  <xsl:param name="filename"/>
  <xsl:param name="lastchange"/>  
  <xsl:param name="section"/>  
  
  <xsl:template match="node()|@*">
    <xsl:copy><xsl:apply-templates select="@* | node()" /></xsl:copy>
  </xsl:template>

  <xsl:template match="dlink-full">
    <a href="{@href}"><xsl:value-of select="@href" /></a>
  </xsl:template> 

  <xsl:template match="page">
    <html>
      <head>
        <title>SuperTux</title>
        <link rel="stylesheet" type="text/css" href="default.css" />
        <link rel="icon" href="images/favicon.png" type="image/png" />
      </head>

      <body>
        <xsl:apply-templates select="document('menu.xml')" />
        <xsl:apply-templates select="document(concat($section, '/submenu.xml'))" />

        <div class="mainbody">
          <xsl:apply-templates />
        </div>

        <div class="copyright">
          Contact via IRC: irc.freenode.net, #supertux<br />

          Contact via <a
            href="http://lists.sourceforge.net/lists/listinfo/super-tux-devel">Mailing
            List</a>: <a
            href="mailto:super-tux-devel@lists.sourceforge.net">super-tux-devel@lists.sourceforge.net</a><br />

          Last update: <xsl:value-of select="$lastchange" /><br />
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="section">
    <div class="section-box">
      <xsl:if test="@id!=''">
        <xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
      </xsl:if>
      <div class="section-title"><h2><xsl:value-of select="@title" /></h2></div>
      <div class="section-body">
        <xsl:apply-templates />
      </div>
    </div>
  </xsl:template>

  <xsl:template match="subsection">
    <h3><xsl:value-of select="@title" /></h3>
    <xsl:apply-templates />
    <br clear="all" />
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
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="news/item">
    <p style="padding: 0em;"><strong><xsl:value-of select="@date" /></strong> - <xsl:apply-templates /></p>
  </xsl:template>

  <xsl:template match="submenu">
    <div class="submenu">
      <table align="center" cellspacing="0" cellpadding="0">
        <tr>
          <xsl:apply-templates />
        </tr>
      </table>
    </div>   
  </xsl:template>

  <xsl:template match="submenu/item">
    <xsl:choose>
      <xsl:when test="contains(@file, $filename)">
        <td><a class="active" href="{@file}"><xsl:apply-templates /></a></td>
      </xsl:when>
      <xsl:otherwise>
        <td><a href="{@file}"><xsl:apply-templates /></a></td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="menu">
    <div class="menu">
      <table align="center">
        <tr>
          <xsl:apply-templates />
        </tr>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="menu/item">
    <xsl:choose>
      <!-- FIXME: Take sections into account -->
      <xsl:when test="contains(@file, $filename)">
        <td><a class="active" href="{@file}"><xsl:apply-templates /></a></td>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$section='.'">
            <td><a href="{@file}"><xsl:apply-templates /></a></td>
          </xsl:when>
          <xsl:otherwise>
            <td><a href="../{@file}"><xsl:apply-templates /></a></td>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="picture">
    <table border="0">
      <tr>
        <td valign="top">
          <img src="{@file}" /> 
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


</xsl:stylesheet>
