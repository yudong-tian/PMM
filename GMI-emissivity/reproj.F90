
        program reproj 

! Read 1-day's worth of GMI emissivity data produced by Joe Munchalk. 
! reproject to 0.25-deg resoluton lat/lon
! and save the gridded data 

!usage:
! ./reproj input_file_list outfile

      implicit none

     interface
      subroutine read_gmi_hdf5(h5file, varname, var, lat, lon, nx, ny, nz)
      character*200, intent(in) :: h5file, varname
      integer, intent(out) :: nx, ny, nz
      ! assuming max dim: 3, lat/lon: 2 
      real, allocatable, intent(out) :: var(:, :, :), lat(:, :), lon(:, :)
      end subroutine
     end interface

      ! batch processing of multiple files
      integer, parameter :: maxfiles = 20   ! normally ~15 
      integer :: nfiles
      character*200 :: inflist, varname
      character*200 :: infiles(maxfiles)
      character*200 :: gradsf   !output for grads format

      ! the swath dimension
      integer ::  nx, ny, nz           ! 
      integer :: i, j, k, iargc, nf, ierr
      real (kind=4), allocatable :: lat(:, :), lon(:, :)
      real (kind=4), allocatable :: var(:, :, :)

      ! scope of output, center of grid
      real, parameter :: minlat=-89.875, maxlat=89.875  !
      real, parameter :: minlon=-179.875, maxlon=179.875 ! global
      real, parameter :: res = 0.25   
      real :: clat, clon

      integer :: nc, nr
      integer, parameter :: nch = 13   ! 3rd dim, number of channels 

      !output data for grads
      real (kind=4), allocatable :: oem(:, :, :), otb(:, :, :)
      real (kind=4), allocatable :: os0ka(:, :, :), os0ku(:, :, :), otype(:, :, :)

      nc = nint( (maxlon - minlon )/res) + 1
      nr = nint( (maxlat - minlat )/res) + 1
      write(*, *) "nc=", nc, " nr=", nr
      allocate(oem(nc, nr, nch))
      allocate(otb(nc, nr, nch))
      allocate(os0ka(nc, nr, 1)) 
      allocate(os0ku(nc, nr, 1)) 
      allocate(otype(nc, nr, 1)) 

     if (iargc() .ne. 2) then
       write(*, *)"usage: hdf5_file_list outfile" 
       stop
     end if
     call getarg(1, inflist)
     call getarg(2, gradsf)

     open(15, file=trim(inflist), form='formatted', status='old')
      nfiles = maxfiles
      Do i=1, maxfiles
         read(15, '(a)', iostat=ierr) infiles(i)
         if (ierr .ne. 0 ) then
           nfiles = i-1
           exit
         end if
      End Do
      Close(15)
      write(*, *) "number of input files: ", nfiles

    oem = -99.0 
    otb = -99.0 
    os0ka = -99.0 
    os0ku = -99.0 
    otype = -99.0 
    Do nf = 1, nfiles

      varname="GMIEmissivity"
      call read_gmi_hdf5(infiles(nf), varname, var, lat, lon, nx, ny, nz)
      write(*, *)trim(infiles(nf)), " nx=", nx, " ny=", ny, " nz=", nz
      call to_grid(oem, nc, nr, nch, var, lat, lon, nx, ny, nz, minlat, maxlat, minlon, maxlon, res)

      varname="GMIObservedBrightnessTemperature"
      call read_gmi_hdf5(infiles(nf), varname, var, lat, lon, nx, ny, nz)
      call to_grid(otb, nc, nr, nch, var, lat, lon, nx, ny, nz, minlat, maxlat, minlon, maxlon, res)

      varname="PRE_sigmaZeroMeasuredKa"
      call read_gmi_hdf5(infiles(nf), varname, var, lat, lon, nx, ny, nz)
      call to_grid(os0ka, nc, nr, 1, var, lat, lon, nx, ny, nz, minlat, maxlat, minlon, maxlon, res)

      varname="PRE_sigmaZeroMeasuredKu"
      call read_gmi_hdf5(infiles(nf), varname, var, lat, lon, nx, ny, nz)
      call to_grid(os0ku, nc, nr, 1, var, lat, lon, nx, ny, nz, minlat, maxlat, minlon, maxlon, res)

      varname="SurfaceTypeIndex"
      call read_gmi_hdf5(infiles(nf), varname, var, lat, lon, nx, ny, nz)
      call to_grid(otype, nc, nr, 1, var, lat, lon, nx, ny, nz, minlat, maxlat, minlon, maxlon, res)

    End Do   ! nfiles

      write(*, *) "Saving binary format ...", nc, nr
      open(22, file=gradsf, form="unformatted", access="direct", recl=nc*nr*4)
        Do k=1, nch
          write(22, rec=k) oem(:, :, k)
        End Do
        Do k=1, nch
          write(22, rec=k+nch) otb(:, :, k)
        End Do

        write(22, rec=nch+nch+1) os0ka(:, :, 1)
        write(22, rec=nch+nch+2) os0ku(:, :, 1)
        write(22, rec=nch+nch+3) otype(:, :, 1)

      close(22)

      deallocate(oem)
      deallocate(otb)
      deallocate(os0ka)
      deallocate(os0ku)
      deallocate(otype)
      stop
      end

      subroutine to_grid(ovar, nc, nr, nch, var, lat, lon, nx, ny, nz, minlat, maxlat, minlon, maxlon, res)
      integer, intent(in) :: nc, nr, nch 
      real, intent(inout)  :: ovar(nc, nr, nch) 
      integer, intent(in) :: nx, ny, nz
      real, intent(in)  :: minlat, maxlat, minlon, maxlon, res 
      real, intent(in)  :: var(nz, ny, nx), lat(ny, nx), lon(ny, nx) 
      
      integer :: i, j, k, ic, ir 
      real :: clat, clon 

      write(*, *)" nx=", nx, " ny=", ny, " nz=", nz
      write(*, *)"to_grid: nc=", size(ovar, 1), " nr=", size(ovar, 2), " nch=", size(ovar, 3) 
      Do k=1, nz   ! max: 13 channels of emissivity

        Do j=1, ny
          Do i=1, nx
             clat=lat(j, i)
             clon=lon(j, i)
             if (clat .GE. minlat .and. clat .LE. maxlat .and. &
                 clon .GE. minlon .and. clon .LE. maxlon) then
               ir = nint ( (clat - minlat )/res ) + 1
               ic = nint ( (clon - minlon )/res ) + 1
             
               !write(*, *)" ic=", ic, " ir=", ir, " k=", k
               ovar(ic, ir, k) = var(k, j, i)   ! only save valid values
             end if
          End Do  ! i
        End Do  ! j

      End Do  ! k

     return 
    end subroutine to_grid


      subroutine read_gmi_hdf5(h5file, varname, var, lat, lon, nx, ny, nz)
      use hdf5

      implicit none

      character*200, intent(in) :: h5file, varname
      integer, intent(out) :: nx, ny, nz
      real, allocatable, intent(out) :: var(:, :, :), lat(:, :), lon(:, :)

      ! declarations
      integer (kind=4) :: fid,swid,status,astat, rank
      integer (hsize_t) :: dims(3),maxdims(3), fdims(1), datatype,i,j, ix, nf
      character (len=255) :: dimlist

      !======= choose the file and field to read
      character*100,   parameter    :: group_name = "/NS"
      character*100,   parameter    :: lon_name = "/NS/Longitude"
      character*100,   parameter    :: lat_name = "/NS/Latitude"
      integer(hid_t)                :: file_id, field_id
      integer(hid_t)                :: lon_id, lat_id
      integer(hid_t)                :: dataspace

      dims = 1
      !======= open the interface
      call h5open_f(status)
      if (status .ne. 0) write(*, *) "Failed to open HDF interface"

      write(*, *) "opening ", trim(h5file) 
      call h5fopen_f(trim(h5file), H5F_ACC_RDONLY_F, file_id, status)
      if (status .ne. 0) write(*, *) "Failed to open HDF file"

      call h5dopen_f(file_id, trim(group_name)//"/"//trim(varname), field_id, status)
      if (status .ne. 0) write(*, *) "Failed to get dataset: ", trim(varname) 

      call h5dget_space_f(field_id, dataspace, status)
      if (status .ne. 0) write(*, *) "Failed to get dataspace id"

      CALL h5sget_simple_extent_ndims_f(dataspace, rank, status)
      if (status .lt. 0) write(*, *) "Failed to get rank, status=", status

      CALL h5sget_simple_extent_dims_f(dataspace, dims, maxdims, status)
      if (status .lt. 0) write(*, *) "Failed to get dims, status=", status
          
      write(*, *)"maxdims=", maxdims, " dims=", dims, " rank=", rank

      nx=1
      ny=1
      nz=1
      nx = dims(rank)
      if (rank .gt. 1) ny = dims(rank-1)
      if (rank .gt. 2) nz = dims(rank-2)

      write(*, *)"in subroutine: nx=", nx, " ny=", ny, " nz=", nz

      if (allocated(var)) deallocate(var)
      if (allocated(lat)) deallocate(lat)
      if (allocated(lon)) deallocate(lon)
      !allocate(var(nx, ny, nz))
      !allocate(lat(nx, ny))
      !allocate(lon(nx, ny))
      allocate(var(nz, ny, nx)) 
      allocate(lat(ny, nx))
      allocate(lon(ny, nx))
      
      ! note: byte order in memory can be different from file if they are the same class 
      !https://www.hdfgroup.org/HDF5/doc1.6/UG/10_Datasets.html
      call h5dread_f(field_id, H5T_IEEE_F32LE, var, dims, status) 
      if (status .ne. 0) write(*, *) "Failed to read ", trim(varname) 

      call h5dopen_f(file_id, lat_name, field_id, status)
      if (status .ne. 0) write(*, *) "Failed to get dataset: ", lat_name

      call h5dread_f(field_id, H5T_IEEE_F32LE, lat, dims, status)
      if (status .ne. 0) write(*, *) "Failed to read lon"

      call h5dopen_f(file_id, lon_name, field_id, status)
      if (status .ne. 0) write(*, *) "Failed to get dataset: ", lon_name

      call h5dread_f(field_id, H5T_IEEE_F32LE, lon, dims, status)
      if (status .ne. 0) write(*, *) "Failed to read lon"

      call h5fclose_f(file_id, status)
      call h5close_f(status)

      return

      end subroutine read_gmi_hdf5 

