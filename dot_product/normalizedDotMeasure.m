function res = normalizedDotMeasure(vec1, vec2)
    res = dot(vec1,vec2) / sqrt(dot(vec1, vec1) * dot(vec2, vec2));
end