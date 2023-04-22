#!/bin/env python

# pip install lxml

import fnmatch
import os
import sys
from lxml import etree

def find_xsd_files(directory):
    xsd_files = []
    for root, _, filenames in os.walk(directory):
        for filename in fnmatch.filter(filenames, "*.xsd"):
            xsd_files.append(os.path.join(root, filename))
    return xsd_files


def convert_xsd_to_owl(xsd_basename, xsd_path, xslt_path, output_path):
    # Parse the XSD file
    xsd_tree = etree.parse(xsd_path)

    # Parse the XSLT file
    xslt_tree = etree.parse(xslt_path)

    # Create an XSLT transformer
    transformer = etree.XSLT(xslt_tree)

    # Transform the XSD tree into an OWL tree
    owl_tree = transformer(xsd_tree, input_file=etree.XSLT.strparam(xsd_basename))

    # Write the OWL tree to the output file
    with open(output_path, "wb") as output_file:
        output_file.write(etree.tostring(owl_tree, pretty_print=True))

def main(base_dir, xslt_file):
    xsd_files = find_xsd_files(base_dir)
    for xsd_file in xsd_files:
        xsd_basename = os.path.basename(xsd_file)
        rdf_file = os.path.join("generated", xsd_basename + ".rdf")
        convert_xsd_to_owl(xsd_basename, xsd_file, xslt_file, rdf_file)

if __name__ == "__main__":
    base_dir = os.path.join(os.sep, "NIEM-Releases-niem-5.2", "xsd")
    xslt_file = 'niem-xsd-to-owl.xsl'
    main(base_dir, xslt_file)
