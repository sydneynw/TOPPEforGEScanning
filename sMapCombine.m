function P = sMapCombine(PS, sMap)
%| Tianrui Luo, University of Michigan
%| 2017
denom = sum(conj(sMap).*sMap,4); % sum up across coil
nom = sum(bsxfun(@times, conj(sMap), PS), 4);
P = bsxfun(@rdivide, nom, denom);
P(isnan(P)) = 0;
end
