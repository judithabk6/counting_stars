function d = mesa_distance(out)
diff = out.trueDensity-out.estimatedDensity;

[ymin1 ymax1 xmin1 xmax1 val1] = maxsubarray2D(diff);
[ymin2 ymax2 xmin2 xmax2 val2] = maxsubarray2D(-diff);
d = max(val1, val2);
end