---
title: Process Variation
---

```
input               output

 x1 -> +---------+ -> y1
 x2 -> | Process | -> y2
 x3 -> +---------+ -> y3

 QA                   QC
```

The above process model could for instance be for an injection
moulding process. On the input side we would have some process
parameters like temperature, pressure, humidity, and timing. On the
output side the dimensions of the part being moulded, which we can
call attributes of the part. That is, process parameters on the input
side and product attributes on the output side.

If the input is stable then all the output is stable and it follows
that variation in input causes variation in output.

Quality Assurance (QA) is done by checking the process parameters and
since this happens before the product is produced this assures the
right quality. Quality Control is done by checking the product
attributes after the product is produced and control is established by
sorting in non-conforming and conforming products.

By including _all_ process parameters on the input side (e.g. the
maintenance standard of the injection moulding machine, the ambient
temperature, the quality of raw material) the process in the model is
only the sum of the input process variables and thereby reduced to
cause-and-effect.
