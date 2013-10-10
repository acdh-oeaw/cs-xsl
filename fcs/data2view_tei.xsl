<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:aac="urn:general"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:sru="http://www.loc.gov/zing/srw/"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:exist="http://exist.sourceforge.net/NS/exist"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    version="1.0" 
    exclude-result-prefixes="xsl aac tei sru html exist xd">

<xd:doc scope="stylesheet">
    <xd:desc> 
<xd:p>Stylesheet for formatting TEI-elements  inside a FCS/SRU-result.
the TEI-elements are expected without namespace (!) (just local names)
This is not nice, but is currently in results like that.</xd:p>
<xd:p>
The templates are sorted by TEI-elements they match.
if the same transformation applies to multiple elements,
it is extracted into own named-template and called from the matching templates.
the named templates are at the bottom.</xd:p>
    </xd:desc>
</xd:doc>
    
    <xd:doc>
        <xd:desc>some special elements retained in data, due to missing correspondencies in tei 
            if it will get more, we should move to separate file</xd:desc>
    </xd:doc>
    <xsl:template match="aac_HYPH1 | aac:HYPH1" mode="record-data">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>some special elements retained in data, due to missing correspondencies in tei 
            if it will get more, we should move to separate file</xd:desc>
    </xd:doc>
    <xsl:template match="aac_HYPH2  | aac:HYPH2" mode="record-data">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>some special elements retained in data, due to missing correspondencies in tei 
            if it will get more, we should move to separate file</xd:desc>
    </xd:doc>
    <xsl:template match="aac_HYPH3  | aac:HYPH3" mode="record-data">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:address elements are mapped to html:address (???) elements
            <xd:p>Suche elements occur in ... </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="address | tei:address" mode="record-data">
        <address>
            <xsl:if test="tei:street">
                <xsl:value-of select="tei:street"/>
                <br/>
            </xsl:if>
            <xsl:if test="tei:postCode | tei:settlement">
                <xsl:value-of select="tei:postCode"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="tei:settlement"/>
                <br/>
            </xsl:if>
            <xsl:if test="tei:country">
                <xsl:value-of select="tei:country"/>
            </xsl:if>
        </address>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:bibl elements are (???)</xd:desc>
    </xd:doc>
    <xsl:template match="bibl | tei:bibl" mode="record-data">
        <xsl:call-template name="inline"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:cit elements are mapped to html:quote elements
            <xd:p>Suche elements occur in ... </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="cit | tei:cit" mode="record-data">
        <quote>
            <xsl:apply-templates mode="record-data"/>
        </quote>
    </xsl:template>
   
    <xd:doc>
        <xd:desc>tei:data elements are formatted as spans with an apropriate class
            <xd:p>Suche elements occur in ... </xd:p>
        </xd:desc>
    </xd:doc>    
    <xsl:template match="date|tei:date" mode="record-data">
        <span class="date">
            <!--<xsl:value-of select="."/>-->
            <xsl:apply-templates mode="record-data"/>
<!--            <span class="note">[<xsl:value-of select="@value"/>]</span>-->
        </span>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:div elements are mapped to html:div elements
            <xd:p>Note: html:div elements are defined even fuzzier than tei:div elements.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="div|tei:div" mode="record-data">
        <div>
            <xsl:if test="@type">
                <xsl:attribute name="class"><xsl:value-of select="concat('tei-type-', @type)"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:p elements are mapped to html:p elements
        </xd:desc>
    </xd:doc>
    <xsl:template match="p|tei:p" mode="record-data">
        <p>
            <xsl:if test="@rend">
                <xsl:attribute name="class"><xsl:call-template name="rend-without-color"><xsl:with-param name="rend-text" select="@rend"/></xsl:call-template></xsl:attribute>
                <xsl:if test="substring-after(string(@rend), 'color(')">
                    <xsl:attribute name="style"><xsl:call-template name="rend-color-as-html-style"><xsl:with-param name="rend-text" select="@rend"/></xsl:call-template></xsl:attribute>
                </xsl:if>
            </xsl:if>
            <xsl:apply-templates mode="record-data"/>
        </p>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:table elements are mapped to html:table elements
            <xd:p>Note: These elements are found eg. in the mecmua transkription.</xd:p>
            <xd:p>There is a class attribute "tei-table" so it is possible to format these
            tables differently form eg. blind tables used elsewhere.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="table|tei:table" mode="record-data">
        <table class="tei-table">
            <xsl:apply-templates mode="record-data"/>
        </table>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:row elements are mapped to html:tr elements
        </xd:desc>
    </xd:doc>
    <xsl:template match="row|tei:row" mode="record-data">
        <tr>
            <xsl:apply-templates mode="record-data"/>
        </tr>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:cell elements are mapped to html:td elements
        </xd:desc>
    </xd:doc>
    <xsl:template match="cell|tei:cell" mode="record-data">
        <td>
            <xsl:if test="./@cols">
                <xsl:attribute name="colspan"><xsl:value-of select="./@cols"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="record-data"/>
        </td>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:hi is mapped to html:span and @rend is mapped to @class</xd:desc>
        <xd:p>Note these elements are found eg. in the mecmua transkription</xd:p>
    </xd:doc>
    <xsl:template match="hi|tei:hi" mode="record-data">
        <span>
            <xsl:if test="@rend">
                <xsl:attribute name="class"><xsl:call-template name="rend-without-color"><xsl:with-param name="rend-text" select="@rend"/></xsl:call-template></xsl:attribute>
                <xsl:if test="substring-after(string(@rend), 'color(')">
                    <xsl:attribute name="style"><xsl:call-template name="rend-color-as-html-style"><xsl:with-param name="rend-text" select="@rend"/></xsl:call-template></xsl:attribute>
                </xsl:if>
            </xsl:if>
            <xsl:apply-templates mode="record-data"/>
        </span>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:entry elements are the base elements for any lexicographical definitions
            <xd:p>
     TODO: this has to be broken down to individual children-elements.
     the styles should be moved to CSS and referenced by classes
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="entry | tei:entry" mode="record-data">
        <div class="profiletext">
            <div style="margin-top: 15px; background:rgb(242,242,242); border: 1px solid grey">
                <b>
                    <xsl:value-of select="form[@type='lemma']/orth[contains(@xml:lang,'Trans')]"/>
                    <xsl:if test="form[@type='lemma']/orth[contains(@xml:lang,'arabic')]">
                        <xsl:text> </xsl:text>(<xsl:value-of select="form[@type='lemma']/orth[contains(@xml:lang,'arabic')]"/>)</xsl:if>
                </b>
                <xsl:if test="gramGrp/gram[@type='pos']">
                    <span style="color:rgb(0,64,0)">
                        <xsl:text>           </xsl:text>[<xsl:value-of select="gramGrp/gram[@type='pos']"/>
                        <xsl:if test="gramGrp/gram[@type='subc']">; <xsl:value-of select="gramGrp/gram[@type='subc']"/>
                        </xsl:if>]</span>
                </xsl:if>
                <xsl:for-each select="form[@type='inflected']">
                    <div style="margin-left:30px">
                        <xsl:choose>
                            <xsl:when test="@ana='#adj_f'">
                                <b style="color:blue">
                                    <i>(f) </i>
                                </b>
                            </xsl:when>
                            <xsl:when test="@ana='#adj_pl'">
                                <b style="color:blue">
                                    <i>(pl) </i>
                                </b>
                            </xsl:when>
                            <xsl:when test="@ana='#n_pl'">
                                <b style="color:blue">
                                    <i>(pl) </i>
                                </b>
                            </xsl:when>
                            <xsl:when test="@ana='#v_pres_sg_p3'">
                                <b style="color:blue">
                                    <i>(pres) </i>
                                </b>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:value-of select="orth[contains(@xml:lang,'Trans')]"/>
                        <xsl:if test="orth[contains(@xml:lang,'arabic')]">
                            <xsl:text> </xsl:text>(<xsl:value-of select="orth[contains(@xml:lang,'arabic')]"/>)</xsl:if>
                    </div>
                </xsl:for-each>
                <xsl:for-each select="sense">
                    <xsl:if test="def">
                        <div style="margin-top: 5px; border-top:0.5px dotted grey;">
                            <xsl:if test="def[@xml:lang='en']">
                                <xsl:value-of select="def[@xml:lang='en']"/>
                            </xsl:if>
                            <xsl:if test="def[@xml:lang='de']">
                                <xsl:text> </xsl:text>
                                <span style="color:rgb(126,126,126); font-style: italic">(<xsl:value-of select="def[@xml:lang='de']"/>)</span>
                            </xsl:if>
                        </div>
                    </xsl:if>
                    <xsl:if test="cit[@type='translation']">
                        <div style="margin-top: 5px; border-top:0.5px dotted grey;">
                            <xsl:if test="cit[(@type='translation')and(@xml:lang='en')]">
                                <xsl:value-of select="cit[(@type='translation')and(@xml:lang='en')]"/>
                            </xsl:if>
                            <xsl:if test="cit[(@type='translation')and(@xml:lang='de')]">
                                <xsl:text> </xsl:text>
                                <span style="color:rgb(126,126,126); font-style: italic">(<xsl:value-of select="cit[(@type='translation')and(@xml:lang='de')]"/>)</span>
                            </xsl:if>
                        </div>
                    </xsl:if>
                    <xsl:for-each select="cit[@type='example']">
                        <div style="margin-left:30px">
                            <xsl:value-of select="quote[contains(@xml:lang,'Trans')]"/>
                            <i>
                                <xsl:value-of select="cit[(@type='translation')and(@xml:lang='en')]"/>
                            </i>
                            <xsl:if test="cit[(@type='translation')and(@xml:lang='de')]">
                                <xsl:text> </xsl:text>
                                <span style="color:rgb(126,126,126); font-style: italic">(<xsl:value-of select="cit[(@type='translation')and(@xml:lang='de')]"/>)</span>
                            </xsl:if>
                        </div>
                    </xsl:for-each>
                </xsl:for-each>
            </div>
        </div>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:foreign elements are formatted as divs with an apropriate language class
            <xd:p>Suche elements occur in ... </xd:p>
        </xd:desc>
    </xd:doc>  
    <xsl:template match="foreign | tei:foreign" mode="record-data">
        <div lang="{@lang}">
            <xsl:apply-templates mode="record-data"/>
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:geo elements are mapped to spans optionally as link to more information.</xd:desc>
    </xd:doc>
    <xsl:template match="geo | tei:geo" mode="record-data">
        <xsl:call-template name="inline"/>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:l elements are expanded and a html:br element as added.</xd:desc>
    </xd:doc>
    <xsl:template match="l | tei:l" mode="record-data">
        <xsl:apply-templates mode="record-data"/>
        <br/>
    </xsl:template>
    <xsl:template match="lb | tei:lb" mode="record-data">
        <br/>
    </xsl:template>
    <xsl:template match="lg | tei:lg" mode="record-data">
        <div class="lg">
            <p>
                <xsl:apply-templates mode="record-data"/>
            </p>
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:milestone elemnts are not retained</xd:desc>
        <xd:p>Replced by three dots (...)</xd:p>
    </xd:doc>
    <xsl:template match="milestone | tei:milestone" mode="record-data">
        <xsl:text>...</xsl:text>
    </xsl:template>
    
    <!-- for STB: dont want pb -->
    <xsl:template match="pb | tei:pb" mode="record-data"/>
    <!--<xsl:template match="pb" mode="record-data">
        <div class="pb">p. <xsl:value-of select="@n"/>
        </div>
    </xsl:template>-->
    <xsl:template match="place | tei:place" mode="record-data">
        <xsl:copy>
            <xsl:apply-templates mode="record-data"/>
        </xsl:copy>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:persName, tei:placeName etc. elements are mapped to spans optionally as link to more information.</xd:desc>
    </xd:doc>
    <xsl:template match="persName | placeName | name | tei:persName | tei:placeName | tei:name" mode="record-data">
        <xsl:call-template name="inline">
            <xsl:with-param name="additional-style" select="string(../@rend)"/>
        </xsl:call-template>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:quote elements are mapped to spans optionally as link to more information.</xd:desc>
    </xd:doc>
    <xsl:template match="quote | tei:quote" mode="record-data">
        <xsl:call-template name="inline"/>
    </xsl:template>
    <xd:doc>
        <xd:desc>tei:rs elements are mapped to spans optionally as link to more information.</xd:desc>
    </xd:doc>
    <xsl:template match="rs | tei:rs" mode="record-data">
        <xsl:call-template name="inline"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tei:seg elements are mapped to spans optionally as link to more information.
        <xd:p>Note: These may not make sense in a particular project eg. STB.</xd:p>
        </xd:desc>
    </xd:doc> 
    <xsl:template match="seg | tei:seg" mode="record-data">
        <xsl:call-template name="inline"/>
    </xsl:template>
    
    <!-- handing over to aac:stand.xsl -->
    <!--<xsl:template match="seg" mode="record-data">
        <xsl:apply-templates select="."/>
    </xsl:template>-->
    <!--
    <xsl:template match="seg[@type='header']" mode="record-data"/>
    <xsl:template match="seg[@rend='italicised']" mode="record-data">
        <em>
            <xsl:apply-templates mode="record-data"/>
        </em>
    </xsl:template>
    -->
    
    <xd:doc>
        <xd:desc>
            <xd:p>a rather sloppy section optimized for result from aacnames listPerson/tei:person
                this should occur only in lists, not in text
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:person" mode="record-data">
        <div class="person">
            <xsl:apply-templates select="tei:birth|tei:death|tei:occupation" mode="record-data"/>
            <xsl:variable name="elem-link">
                <xsl:call-template name="elem-link"/>
            </xsl:variable>
            <a href="{$elem-link}">
                <xsl:value-of select="tei:persName"/> in text</a>      

            <!--<div class="links">
                <ul>
                    <xsl:apply-templates select="tei:link" mode="record-data"/>
                </ul>
            </div>-->
        </div>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Suppressed. Already used as a title.
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:person/tei:persName" mode="record-data"/>
    
    <xd:doc>
        <xd:desc>Suppressed. Not really nice for output. (???)
        </xd:desc>
    </xd:doc>
    <xsl:template match="tei:sex" mode="record-data"/>
    
    <xsl:template match="tei:birth" mode="record-data">
        <div>
            <span class="label">geboren: </span>
            <span class="{local-name()}" data-when="{@when}">
                <xsl:value-of select="concat(@when, ', ', tei:placeName)"/>
            </span>
        </div>
    </xsl:template>
    <xsl:template match="tei:death" mode="record-data">
        <div>
            <span class="label">gestorben: </span>
            <span class="{local-name()}" data-when="{@when}">
                <xsl:value-of select="concat(@when, ', ', tei:placeName)"/>
            </span>
        </div>
    </xsl:template>
    <xsl:template match="tei:occupation" mode="record-data">
        <div class="{local-name()}">
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    <xsl:template match="tei:link" mode="record-data">
        <li>
            <a href="{@target}">
                <xsl:value-of select="@target"/>
            </a>
        </li>
    </xsl:template>
    <xsl:template match="w|tei:w" mode="record-data">
        <xsl:call-template name="inline"/>
        <!--<span class="w-wrap" >        
        <xsl:if test="@*">
            <span class="attributes" style="display:none;">
                <xsl:value-of select="concat(@lemma,' ',@type)" />
<!-\-                <xsl:apply-templates select="@*" mode="format-attr"/>-\->
            </span>
        </xsl:if>
         <xsl:call-template name="inline" />
        </span>-->
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Get the "argument" of color() used in @rend attributes and return it as html inline style attribute.
            <xd:p>Note: assumes only one color().</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="rend-color-as-html-style">
        <xsl:param name="rend-text"/>
        <xsl:choose>
            <xsl:when test="substring-after(string($rend-text), 'color(')">color: #<xsl:value-of select="substring-before(substring-after(string($rend-text), 'color('), ')')"/>;</xsl:when>
            <xsl:otherwise>
                <!-- there is nothing that could be returened, is there? -->
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Get everything but the color() part in @rend attributes
            <xd:p>Note: assumes only one color().</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="rend-without-color">
        <xsl:param name="rend-text"/>
        <xsl:choose>
            <xsl:when test="substring-after(string($rend-text), 'color(')"><xsl:value-of select="substring-after(substring-before(string($rend-text), 'color('), ')')"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="string($rend-text)"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>