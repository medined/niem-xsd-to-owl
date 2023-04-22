<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xml:base="http://www.w3.org/2002/07/owl"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:appinfo="http://release.niem.gov/niem/appinfo/5.0/"
    exclude-result-prefixes="xsd"
>

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:param name="input_file"/>

    <xsl:template match="/">
        <rdf:RDF><xsl:text>&#xa;</xsl:text>
            <owl:Ontology rdf:about="http://codebits.com"/><xsl:text>&#xa;</xsl:text>
            <owl:Class rdf:about="#{$input_file}"><xsl:text>&#xa;</xsl:text>
                <rdfs:label><xsl:value-of select="$input_file"/></rdfs:label><xsl:text>&#xa;</xsl:text>
                <rdfs:comment>Marker class to aggregate classes for this file.</rdfs:comment><xsl:text>&#xa;</xsl:text>
            </owl:Class>
            <xsl:apply-templates/>
        </rdf:RDF><xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="xs:documentation"/>

    <xsl:template match="xs:simpleType">
        <owl:Class rdf:about="#{current()/@name}"><xsl:text>&#xa;</xsl:text>
            <rdfs:subClassOf rdf:resource="#{$input_file}"/><xsl:text>&#xa;</xsl:text>
            <rdfs:comment><xsl:value-of select="xs:annotation/xs:documentation/."/></rdfs:comment><xsl:text>&#xa;</xsl:text>
        </owl:Class><xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates select="xs:restriction/xs:enumeration"/>
    </xsl:template>

    <xsl:template match="xs:restriction/xs:enumeration">
        <owl:NamedIndividual rdf:about="#{current()/@value}"><xsl:text>&#xa;</xsl:text>
            <rdfs:label><xsl:value-of select="xs:annotation/xs:documentation/."/></rdfs:label><xsl:text>&#xa;</xsl:text>
            <rdf:type rdf:resource="#{../../@name}"/><xsl:text>&#xa;</xsl:text>
        </owl:NamedIndividual><xsl:text>&#xa;</xsl:text>       
    </xsl:template>

</xsl:stylesheet>
