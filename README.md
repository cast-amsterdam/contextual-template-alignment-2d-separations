# contextual-template-alignment-2d-separations
This repository contains the Matlab code accompanying the work entitled “Contextual automated template alignment for 2D group type separations with univariate detection” by Nino B. L. Milani, Ferry de Kruijff, Alan R. Garcia Cicourel, Rob Edam, Tijmen S. Bos, and Bob W. J. Pirok.

The methodology and implementation presented here were developed within the Analytical Chemistry Group at the Van ’t Hoff Institute for Molecular Sciences, University of Amsterdam, in collaboration with the Centre for Analytical Sciences Amsterdam (CASA) and Shell Global Solutions International B.V. The code provides a computational framework for contextual automated alignment of two-dimensional separation templates using univariate detection, as described in the associated publication.

This repository is intended to support transparency, reproducibility, and further methodological development by providing access to the core algorithms used in the study.

Corresponding author:
Bob W. J. Pirok
E-mail: B.W.J.Pirok@uva.nl

## Overview

The MoveTemplate function is the primary entry point of this repository. It performs automated template alignment by adjusting template nodes based on corresponding peak locations between two datasets. Users are expected to provide all required inputs directly at the beginning of the script, as indicated within the file.

## Prerequisites

To successfully run MoveTemplate, the following inputs must be provided:

Peak locations in the dataset with an existing template
(o): coordinates of the detected peaks associated with the reference template.

Peak locations in the dataset requiring a template
(a): coordinates of the corresponding peaks in the target dataset.

X-coordinates of existing template nodes
(temp_xpoints).

Y-coordinates of existing template nodes
(temp_ypoints).

Template box identifiers
(temp_names): names or labels associated with each template region.

## User-defined settings

Weight parameters (suggested values: [1, 100, 0.1, 0.0001])

Normalization values corresponding to the upper bounds of each dimension.

## Important Note

This implementation does not include peak tracking or peak matching between the two sets of apexes. The correspondence between peaks in o and a must be established externally by the user and supplied as input.

## Execution and Output

Once all prerequisites are satisfied, the MoveTemplate script can be executed. Successful execution results in a newly aligned template, returned as NewTemplate.

## Supporting Functions

The following auxiliary functions are required for the correct operation of MoveTemplate and must be accessible in the same directory:

MoveNode
Iteratively invoked by MoveTemplate to update the position of individual template nodes.

trivec
Constructs the vector representation used in the node movement procedure.

TripleUniqueCombinations
Eliminates redundant candidate combinations to improve computational efficiency.

Ensure that all supporting functions are available in the same folder as MoveTemplate prior to execution.
