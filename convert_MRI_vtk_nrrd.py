#!/bin/env python
"""
convert_MRI_vtk_nrrd.py

Convert all MRI VTK label maps that Chris Kauffman generated in itksnap and
convert the legacy format to NRRD files that 3D Slicer can directly read.

For some reason, 3D Slicer crashes when trying to directly load the legacy VTK
format (not sure why), but it works well with NRRD files.  itksnap can do that
conversion for us, but that is interactive, so I am leveraging c3d for the task
(developed by the itksnap folks), which can be run from the CLI and batched.

We will only look at P56-P016; earlier cases with old ultrasound configurations
will not be considered.

Mark Palmeri
2014-11-24
"""


def main():
    import os
    import count_prostate_cases as cpc

    invivo = '/luscinia/ProstateStudy/invivo'

    c3d = '/usr/local/c3d-1.0.0-Linux-x86_64/bin/c3d'

    for root, dirs, files in os.walk(invivo):
        if 'MRI_Images' in os.path.basename(root):
            Pnum = cpc.extract_Pnum(root)
            vtk_filename = 'P%s_segmentation_final.vtk' % Pnum
            print 'Examing P%s/MRI_Images directory for %s' % (Pnum,
                                                               vtk_filename)
            if vtk_filename in files:
                nrrd_filename = vtk_filename.replace('.vtk', '.nrrd')
                os.system('%s %s/%s -type ushort -o %s/%s' % (c3d, root,
                                                              vtk_filename,
                                                              root,
                                                              nrrd_filename))
                print '\tCreated %s in %s.' % (nrrd_filename, root)


if __name__ == '__main__':
    main()
