function d = counting_distance(out)
% out is a struct with 4 fields, .estimatedCount [nb_images], .trueCount,
%   .estimatedDensity [nb_images_, .trueDensity]

d = abs(out.estimatedCount - out.trueCount);
end