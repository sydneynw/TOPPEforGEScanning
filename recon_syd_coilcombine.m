function [im_sc, im_mc] = recon_syd_coilcombine(pfile,readout,datdir,varargin)
%| function [im_sc, im_mc] = recon_syd_coilcombine(pfile,readout,datidir,varargin)
%| recon_syd_coilcombine.m
%| reconstructs multi-coil data and combines complex data if sensitivity map
%| provided, otherwise Sum-of-Squares
%| Sydney Williams, University of Michigan
%| 04.30.2018
%|
%| Inputs:
%| pfile            [char]          P*7 file 
%| readout       	[char]          .mod file
%| datdir        	[char]          directory where data lives
%| (optional)
%| 'mask'           [Nx Ny Nz Nc]   logical support mask of image
%| 'smap'        	[Nx Ny Nz Nc]   sensitivity map for multi-channel data
%|
%| Outputs:
%| im_sc            [Nx Ny Nz]      coil-combined complex data in image domain
%| im_mc            [Nx Ny Nz Nc]   multi-coil complex data in image domain

arg.smap=[];
arg.mask=[];
arg=vararg_pair(arg, varargin);  	% reads in user-provided values

% reconstruct multicoil data
im_mc=recon_syd([datdir,pfile],[datdir,readout]);
% combine multicoil images
if ~isempty(arg.smap)               % if user-provided sensitivity map
    if isempty(arg.mask)            % if no logical mask, all 1's
       arg.mask=ones(size(im_mc));
    end
    im_sc=sMapCombine(im_mc.*arg.mask, arg.smap); % complex coil combine
else
    im_sc=sqrt(sum(abs(im_mc).^2,4));% Sum-of-Squares combination
end


return