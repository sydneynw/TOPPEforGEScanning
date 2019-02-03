function [ims imsos draw] = recon_syd(pfile,readout,varargin)
%function [ims imsos draw] = recon_syd(pfile,readout,varargin)
% recon_syd.m
%| recon script for cartesian readout in
%| toppe7d inspired by xsense@brooks:~/autorecon/sos3d/data/recon.m
%| Sydney Williams, University of Michigan
%| 04.07.2015
%| Edit: 09.13.2017 Adjusted from .wav to .mod files for toppe.e V1
%| Edit: 10.26.2017 Added number of frequency encodes as input
%| Edit: 02.01.2018 Adapted to use loadpfile.m for toppe.e V2
%| Edit: 07.20.2018 Adapted to use loadpfile.m for DV26 (using Jon's recon3dft.m)

%| Inputs:
%| [pfile]             [1]  P*7 file and directory/location
%| [readout]           [1]  .mod file and directory/location
%| (optional)
%| [zread]             [0|1] adjusts/shifts data for 2D readout in Gz (default=0)
%| [echo]              [n]   echo number to reconstruct (default=1 for single echo sequence, multiple echoes in GIRF experiment) 
%| [bodycoil]          [0|1] set to 1 if using bodycoil (default=0) 
%|
%| Outputs:
%| ims   [nx ny nz ncoils]  complex data in image domain
%| imsos [nx ny nz]         root sum-of-squares data in image domain
%| draw  [ndat ny nz ncoils]raw kspace data

arg.zread=0;                % for 2D readout in Gz (slice profiles)
arg.bodycoil=0;             % flips data orientation if body coil receive
arg.echo=1;                 % number of echoes
arg.dokzft=true;            % do FFT in third kz direction
arg.zpad=[1 1];             % zeropad amount in [kx ky]
arg=vararg_pair(arg, varargin);                     % reads in user-provided values

d = loadpfile(pfile,arg.echo);      % int16. [ndat ncoils nslices nechoes nviews] = [ndat ncoils nz 2 ny]
d = permute(d,[1 5 3 2 4]);         % [ndat ny nz ncoils nechoes]
d = double(d);

% get flat portion of readout
[desc,rho,theta,gx,gy,gz,paramsint16,paramsfloat] = readmod(readout);
nramp = 0;                          % see mat2mod.m
nbeg = paramsint16(3) + nramp;      % beginning of data on readout 
if paramsint16(4)
    nx = paramsint16(4);            % number of acquired data samples per TR
    decimation = paramsint16(10);
    d = d(nbeg:(nbeg+nx-1),:,:,:,:);% [nx*125/oprbw ny nz ncoils nechoes]
else
    nx=size(d,1);                   %paramsint16(2);
    decimation=1;
end

if arg.zpad(2) > 1                  % adds zero-padding
	[ndat ny nz ncoils nechoes] = size(d);
	d2 = zeros([ndat ny round(nz*zpad(2)) ncoils]);
	d2(:,:,(end/2-nz/2):(end/2+nz/2-1),:,:) = d;
	d = d2; clear d2;
end

% recon (inverse FFT)
for coil = 1:size(d,4)
	fprintf(1,'recon coil %d\n', coil);
    imstmp = ift3(d(:,:,:,coil),arg.dokzft);
	imstmp = imstmp(end/2+((-nx/decimation/2):(nx/decimation/2-1))+1,:,:);               % [nx ny nz]
	if arg.zpad(1) > 1   % zero-pad (interpolate) in xy
		dtmp = fft3(imstmp);
		[nxtmp nytmp nztmp] = size(dtmp);
		dtmp2 = zeros([round(nxtmp*zpad(1)) round(nytmp*zpad(1)) nztmp]);
		dtmp2((end/2-nxtmp/2):(end/2+nxtmp/2-1),(end/2-nytmp/2):(end/2+nytmp/2-1),:) = dtmp;
		dtmp = dtmp2; clear dtmp2;
		imstmp = ift3(dtmp);
	end
	ims(:,:,:,coil) = imstmp;
end

% flips bodycoil images
if arg.bodycoil
    for i=1:size(ims,3)
        ims(:,:,i)=flipud(permute(ims(:,:,i),[2 1]));
    end
end

if arg.zread
    ims=circshift(ims,-nx/2,2);     % for 2D readout in Gz
end

if size(ims,4)>1
    imsos = sqrt(sum(abs(ims).^2,4)); % root sum-of-squares image  
else
    imsos = ims; % root sum-of-squares image  
end
draw =squeeze(d);
function im = ift3(D,do3dfft)
%
%	function im = ift3(dat)
%
%	Function does a centered inverse 3DFT of a 3D data matrix.
% 
% $Id: ift3.m,v 1.8 2014/07/31 20:49:37 xsense Exp $
if ~exist('do3dfft','var')
    do3dfft = true;
end
if do3dfft
    im = fftshift(ifftn(fftshift(D)));
else
    % don't do fft in 3rd dimension
    for k = 1:size(D,3)
        im(:,:,k) = fftshift(ifftn(fftshift(D(:,:,k))));
    end
end
return;

return;
