<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/dc/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:cavpp="http://calpreservation.org/projects/audiovisual-preservation/">
    <xsl:output method="xml" indent="yes" />

    <xsl:template match="cavpp:cavpp">
        <oai_dc:dc xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
            <xsl:call-template name="title" />
            <xsl:call-template name="alternativeTitle"/>
            <!-- DC:Creator -->
            <xsl:call-template name="creator"/>

            <!-- DC:Subject-->
            <xsl:call-template name="subjectTopic"/>

            <!-- DC:Description -->
            <xsl:call-template name="description"/>
            <xsl:call-template name="additionalDescriptive"/>

            <!-- DC:Publisher -->
            <xsl:call-template name="publisher"/>

            <!-- DC:Contributor -->
            <xsl:call-template name="contributor"/>

            <!-- DC:Date-->
            <xsl:call-template name="year"/>

            <!-- DC:Type -->
            <xsl:call-template name="genre"/>
            <xsl:call-template name="mediaType"/>

            <!-- DC:Format -->
            <xsl:call-template name="generation"/>
            <xsl:call-template name="gauge"/>
            <xsl:call-template name="duration"/>
            <xsl:call-template name="silentSound"/>
            <xsl:call-template name="colorBW"/>
            <xsl:call-template name="channelConfig"/>

            <!-- DC:Identifier -->
            <xsl:call-template name="callNumber"/>
            <xsl:call-template name="objectID"/>

            <!-- DC:Language-->
            <xsl:call-template name="language"/>

            <!-- DC:Coverage-->
            <xsl:call-template name="coverage"/>

            <!-- DC:Rights-->
            <xsl:call-template name="copyrightStatement"/>
            <xsl:call-template name="copyrightHolder"/>
            <xsl:call-template name="copyrightHolderInfo"/>
            <xsl:call-template name="copyrightDate"/>
            <xsl:call-template name="copyrightNotice"/>

        </oai_dc:dc>
    </xsl:template>

    <!-- DC:Title -->
    <!-- Title -> DC:Title -->
    <xsl:template name="title" match="cavpp:Title/cavpp:value[normalize-space(text())]">
        <xsl:variable name="title" select="cavpp:DescriptiveMetadata/cavpp:Title/cavpp:value[normalize-space(text())]"></xsl:variable>
        <xsl:choose>
            <xsl:when test="$title">
                <dc:title><xsl:value-of select="$title"/></dc:title>
            </xsl:when>
            <xsl:otherwise>
                <dc:title>Unknown</dc:title>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- alternative -->
    <xsl:template name="alternativeTitle" match="cavpp:AdditionalTitle/cavpp:value[normalize-space(text())]">
        <xsl:for-each select="cavpp:DescriptiveMetadata/cavpp:AdditionalTitles/cavpp:AdditionalTitle/cavpp:value[normalize-space(text())]">
            <dc:alternative><xsl:value-of select="normalize-space(text())"/></dc:alternative>
        </xsl:for-each>
    </xsl:template>


    <!-- DC:Creator -->
    <!-- Creator -> DC:Creator-->
    <xsl:template name="creator" match="cavpp:Creator">
        <xsl:for-each select="cavpp:DescriptiveMetadata/cavpp:Creators/cavpp:Creator">

            <xsl:variable name="person" select="normalize-space(cavpp:name)"/>
            <xsl:variable name="role" select="normalize-space(cavpp:role)"/>
            <xsl:if test="$role">
                <xsl:choose>
                    <xsl:when test="$role">
                        <dc:creator><xsl:value-of select="$person"/> (<xsl:value-of select="$role"/>)</dc:creator>
                    </xsl:when>
                    <xsl:otherwise>
                        <dc:creator><xsl:value-of select="$person"/></dc:creator>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>


    <!-- DC:Subject-->
    <!-- SubjectTopic -> subject -->
    <xsl:template name="subjectTopic" match="cavpp:SubjectTopic">
        <xsl:for-each select="cavpp:DescriptiveMetadata/cavpp:SubjectTopics/cavpp:SubjectTopic">
            <xsl:variable name="subject" select="normalize-space(cavpp:value)"/>
            <xsl:if test="$subject">
                <dc:subject><xsl:value-of select="$subject"/></dc:subject>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- DC:Description -->
    <!-- Description -> DC:Description -->
    <xsl:template name="description" match="cavpp:Description">
        <xsl:for-each select="cavpp:DescriptiveMetadata/cavpp:Descriptions/cavpp:Description">


            <xsl:variable name="value" select="normalize-space(cavpp:value)"/>
            <xsl:variable name="type">
                <xsl:choose>
                    <xsl:when test="normalize-space(cavpp:type)">(<xsl:value-of select="normalize-space(cavpp:type)"/>)</xsl:when>
                </xsl:choose>
            </xsl:variable>

            <xsl:if test="$value">
                <dc:description><xsl:value-of select="$value"/> <xsl:value-of select="$type"/></dc:description>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- AdditionalDescriptiveNotesForOverallWork -> DC:Description -->
    <xsl:template name="additionalDescriptive" match="cavpp:AdditionalDescriptiveNotesForOverallWork/cavpp:note[normalize-space(text())]">
        <xsl:for-each select="cavpp:DescriptiveMetadata/cavpp:AdditionalDescriptiveNotesForOverallWork/cavpp:note[normalize-space(text())]">
            <dc:description><xsl:value-of select="normalize-space(text())"/></dc:description>
        </xsl:for-each>

    </xsl:template>

    <!-- DC:Publisher -->
    <!-- Publisher -->
    <xsl:template name="publisher" match="cavpp:Publisher">
        <xsl:for-each select="cavpp:DescriptiveMetadata/cavpp:Publishers/cavpp:Publisher">
            <xsl:variable name="name" select="normalize-space(cavpp:name)"/>
            <xsl:variable name="role" select="normalize-space(cavpp:role)"/>
            <xsl:if test="$name">
                <xsl:choose>
                    <xsl:when test="$role">
                        <dc:publisher><xsl:value-of select="$name"/> (<xsl:value-of select="$role"/>)</dc:publisher>
                    </xsl:when>
                    <xsl:otherwise>
                        <dc:publisher><xsl:value-of select="$name"/></dc:publisher>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>

    </xsl:template>

    <!-- DC:Contributor -->
    <!-- Contributor -> DC:Contributor -->
    <xsl:template name="contributor" match="cavpp:Contributor/cavpp:name[normalize-space(text())]">
        <xsl:for-each select="cavpp:DescriptiveMetadata/cavpp:Contributors/cavpp:Contributor">
            <xsl:variable name="name" select="normalize-space(cavpp:name)"/>
            <xsl:variable name="role" select="normalize-space(cavpp:role)"/>
            <xsl:if test="$name">
                <xsl:choose>
                    <xsl:when test="$role">
                        <dc:contributor><xsl:value-of select="$name"/> (<xsl:value-of select="$role"/>)</dc:contributor>
                    </xsl:when>
                    <xsl:otherwise>
                        <dc:contributor><xsl:value-of select="$name"/></dc:contributor>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

        </xsl:for-each>
    </xsl:template>


    <!-- DC:Date-->
    <!-- year -> date -->
    <xsl:template name="year" match="cavpp:Year">
        <xsl:for-each select="cavpp:DescriptiveMetadata/cavpp:Years/cavpp:Year">
            <xsl:variable name="year" select="normalize-space(cavpp:year)"/>
            <xsl:variable name="dateType" select="normalize-space(cavpp:dateType)"/>
            <xsl:if test="$year">

                <xsl:choose>
                    <xsl:when test="$dateType">
                        <dc:date><xsl:value-of select="$year"/> (<xsl:value-of select="normalize-space(cavpp:dateType)"/>)</dc:date>
                    </xsl:when>
                    <xsl:otherwise>
                        <dc:date><xsl:value-of select="$year"/></dc:date>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>

        </xsl:for-each>
    </xsl:template>

    <!-- DC:Type -->
    <!-- Genre -> Type -->
    <xsl:template name="genre" match="cavpp:DescriptiveMetadata/cavpp:genre/cavpp:value[normalize-space(text())]">
        <xsl:variable name="genre" select="cavpp:DescriptiveMetadata/cavpp:genre/cavpp:value[normalize-space(text())]"/>
        <xsl:if test="$genre">
            <dc:type><xsl:value-of select="$genre"/></dc:type>
        </xsl:if>
    </xsl:template>

    <!-- Media Type -> type -->
    <xsl:template name="mediaType" match="cavpp:AdministrativeMetadata/cavpp:mediaType[normalize-space(text())]">
        <xsl:variable name="mediaType" select="cavpp:AdministrativeMetadata/cavpp:mediaType[normalize-space(text())]"/>
        <xsl:if test="$mediaType">
            <dc:type><xsl:value-of select="$mediaType"/></dc:type>
        </xsl:if>

    </xsl:template>

    <!-- DC:Format -->
    <!-- Generation -> format -->
    <xsl:template name="generation" match="cavpp:TechnicalMetadataAboutOriginal/cavpp:generation[normalize-space(text())]">
        <xsl:variable name="generation" select="cavpp:TechnicalMetadataAboutOriginal/cavpp:generation[normalize-space(text())]"/>
        <xsl:if test="$generation">
            <dc:format><xsl:value-of select="$generation"/> (generation)</dc:format>
        </xsl:if>
    </xsl:template>

    <!-- Gauge and Format -> format -->
    <xsl:template name="gauge" match="cavpp:TechnicalMetadataAboutOriginal/cavpp:gaugeAndFormat[normalize-space(text())]">
        <xsl:variable name="gauge" select="cavpp:TechnicalMetadataAboutOriginal/cavpp:gaugeAndFormat[normalize-space(text())]"/>
        <xsl:if test="$gauge">
            <dc:format><xsl:value-of select="$gauge"/></dc:format>
        </xsl:if>

    </xsl:template>

    <!-- Duration -> format -->
    <xsl:template name="duration" match="cavpp:TechnicalMetadataAboutOriginal/cavpp:duration[normalize-space(text())]">
        <xsl:variable name="duration" select="cavpp:TechnicalMetadataAboutOriginal/cavpp:duration[normalize-space(text())]"/>
        <xsl:if test="$duration">
            <dc:format><xsl:value-of select="$duration"/></dc:format>
        </xsl:if>
    </xsl:template>

    <!-- Silent or Sound -> format -->
    <xsl:template name="silentSound" match="cavpp:TechnicalMetadataAboutOriginal/cavpp:silentOrSound[normalize-space(text())]">
        <xsl:variable name="silentSound" select="cavpp:TechnicalMetadataAboutOriginal/cavpp:silentOrSound[normalize-space(text())]"/>
        <xsl:if test="$silentSound">
            <dc:format><xsl:value-of select="$silentSound"/></dc:format>
        </xsl:if>
    </xsl:template>

    <!-- Color or Black and White -> format -->
    <xsl:template name="colorBW" match="cavpp:TechnicalMetadataAboutOriginal/cavpp:colorOrBlackAndWhite[normalize-space(text())]">
        <xsl:variable name="colorBW" select="cavpp:TechnicalMetadataAboutOriginal/cavpp:colorOrBlackAndWhite[normalize-space(text())]"/>
        <xsl:if test="$colorBW">
            <dc:format><xsl:value-of select="$colorBW"/></dc:format>
        </xsl:if>
    </xsl:template>

    <!-- Channel Configuration -> format -->
    <xsl:template name="channelConfig" match="cavpp:TechnicalMetadataAboutOriginal/cavpp:channelConfiguration[normalize-space(text())]">
        <xsl:variable name="channelConfig" select="cavpp:TechnicalMetadataAboutOriginal/cavpp:channelConfiguration[normalize-space(text())]"/>
        <xsl:if test="$channelConfig">
            <dc:format><xsl:value-of select="$channelConfig"/></dc:format>
        </xsl:if>
    </xsl:template>

    <!-- DC:Identifier -->
    <!-- Call number -> identifier -->
    <xsl:template name="callNumber" match="cavpp:DescriptiveMetadata/cavpp:CallNumber/cavpp:CallNumber/cavpp:value[normalize-space(text())]">
        <xsl:for-each select="cavpp:DescriptiveMetadata/cavpp:CallNumber">
            <dc:identifer><xsl:value-of select="cavpp:CallNumber/cavpp:value[normalize-space(text())]"/></dc:identifer>
        </xsl:for-each>

    </xsl:template>

    <!-- Object Identifier -->


    <xsl:template name="objectID" match="cavpp:AdministrativeMetadata/cavpp:ObjectIdentifiers">
        <xsl:for-each select="cavpp:AdministrativeMetadata/cavpp:ObjectIdentifiers/cavpp:objectIdentifier">
            <dc:identifier><xsl:value-of select="normalize-space(text())"/></dc:identifier>

        </xsl:for-each>

    </xsl:template>

    <!-- DC:Source -->

    <!-- DC:Language-->
    <!-- Language -->
    <xsl:template name="language" match="cavpp:LanguagesOfMaterial/cavpp:language[normalize-space(text())]">
        <xsl:for-each select="cavpp:DescriptiveMetadata/cavpp:LanguagesOfMaterial/cavpp:language">
            <dc:language><xsl:value-of select="normalize-space(text())"/></dc:language>
        </xsl:for-each>

    </xsl:template>

    <!-- DC:Coverage-->
    <!-- Coverage -> DC:Coverage -->

    <xsl:template name="coverage" match="cavpp:Coverage/cavpp:value[normalize-space(text())]">
        <xsl:for-each select="cavpp:DescriptiveMetadata/cavpp:Coverages/cavpp:Coverage/cavpp:value">
            <dc:coverage><xsl:value-of select="normalize-space(text())"/></dc:coverage>
        </xsl:for-each>

    </xsl:template>

    <!-- DC:Rights-->
    <!-- Rights Metadata -->
    <!-- Copyright Statement -> rights -->
    <xsl:template name="copyrightStatement" match="cavpp:copyrightStatement[normalize-space(text())]">
        <xsl:variable name="copyrightStatement" select="cavpp:RightsMetadata/cavpp:copyrightStatement[normalize-space(text())]"/>
        <xsl:if test="$copyrightStatement">
            <dc:rights><xsl:value-of select="$copyrightStatement"/></dc:rights>
        </xsl:if>


    </xsl:template>

    <!-- Copyright Holder -> rights -->
    <xsl:template name="copyrightHolder" match="cavpp:copyrightHolder[normalize-space(text())]">
        <xsl:variable name="copyrightHolder" select="cavpp:RightsMetadata/cavpp:copyrightHolder[normalize-space(text())]"/>
        <xsl:if test="$copyrightHolder">
            <dc:rights><xsl:value-of select="$copyrightHolder"/></dc:rights>
        </xsl:if>


    </xsl:template>

    <!-- Copyright Holder Info -> rights -->
    <xsl:template name="copyrightHolderInfo" match="cavpp:copyrightHolderInfo[normalize-space(text())]">
        <xsl:variable name="copyrightHolderInfo" select="cavpp:RightsMetadata/cavpp:copyrightHolderInfo[normalize-space(text())]"/>
        <xsl:if test="$copyrightHolderInfo">
            <dc:rights><xsl:value-of select="$copyrightHolderInfo"/></dc:rights>
        </xsl:if>


    </xsl:template>

    <!-- Copyright Date -> rights -->
    <xsl:template name="copyrightDate" match="cavpp:copyrightDate[normalize-space(text())]">
        <xsl:variable name="copyrightDate" select="cavpp:RightsMetadata/cavpp:copyrightDate[normalize-space(text())]"/>
        <xsl:if test="$copyrightDate">
            <dc:rights><xsl:value-of select="$copyrightDate"/></dc:rights>
        </xsl:if>

    </xsl:template>

    <!-- Copyright Notice -> rights -->
    <xsl:template name="copyrightNotice" match="cavpp:copyrightNotice[normalize-space(text())]">
        <xsl:variable name="copyrightNotice" select="cavpp:RightsMetadata/cavpp:copyrightNotice[normalize-space(text())]"/>
        <xsl:if test="$copyrightNotice">
            <dc:rights><xsl:value-of select="$copyrightNotice"/></dc:rights>
        </xsl:if>

    </xsl:template>


</xsl:stylesheet>
