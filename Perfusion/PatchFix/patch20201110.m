function obj = patch20201110(obj, AIF, sliceA, VIF, sliceV)

%%Originally stored ROI stats as separate mat files. This patch imports
% those ROIs and stores them in the perfusion obj.
% Implemented 20201110.

%%

    obj.stats.AIF = AIF;
    obj.stats.AIF.slice = sliceA;
    obj.stats.VIF = VIF;
    obj.stats.VIF.slice = sliceV;
    
end