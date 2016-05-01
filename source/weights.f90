module mod_weights
use mod_abundtypes
use mod_abundIO
contains

subroutine setweights(configfile,weights,linelist,ILs)
!will read configuration file in containing all the weights. currently just sets them.

        implicit none
        integer, parameter :: dp=kind(1.d0)
        character(len=512) :: configfile
        character(len=16) :: quantity
        character(len=24) :: filecheck
        real(kind=dp) :: weight
        type(weightingarray) :: weights
        type(line),dimension(:) :: linelist
        type(cel),dimension(82) :: ILs
        integer :: io

!open config file

        open(631, file=trim(configfile),iostat=io,status="old")
        read(631,"(24A)") filecheck

        if (filecheck .ne. "#NEAT configuration file") then
          print *,"           ",trim(configfile)," doesn't appear to be a NEAT configuration file"
          stop
        endif

        do while (IO .ge. 0)
          read(631,*,end=111) quantity
          if (quantity(1:1).ne."#") then
            backspace(631)
            read(631,"(A16,F5.2)") quantity,weight

!conditions for weight assignment here. it's going to be ugly, no way around it

!low ionisation densities
            if (trim(quantity).eq."oiiDens") then
              weights%oiiDens = weight
              cycle
            elseif (trim(quantity).eq."siiDens") then
              weights%siiDens = weight
              cycle
            !low ionisation temperatures
            elseif (trim(quantity).eq."oiiTemp") then
              weights%oiiTemp = weight
              cycle
            elseif (trim(quantity).eq."siiTemp") then
              weights%siiTemp = weight
              cycle
            elseif (trim(quantity).eq."niiTemp") then
              weights%niiTemp = weight
              cycle
            elseif (trim(quantity).eq."ciTemp") then
              weights%ciTemp = weight
              cycle
            elseif (trim(quantity).eq."oiTemp") then
              weights%oiTemp = weight
              cycle
            !medium ionisation densities
            elseif (trim(quantity).eq."cliiiDens") then
              weights%cliiiDens = weight
              cycle
            elseif (trim(quantity).eq."ciiiDens") then
              weights%ciiiDens = weight
              cycle
            elseif (trim(quantity).eq."arivDens") then
              weights%arivDens = weight
              cycle
            elseif (trim(quantity).eq."oiiiIRDens") then
              weights%oiiiIRDens = weight
              cycle
            elseif (trim(quantity).eq."ariiiIRDens") then
              weights%ariiiIRDens = weight
              cycle
            elseif (trim(quantity).eq."siiiIRDens") then
              weights%siiiIRDens = weight
              cycle
            elseif (trim(quantity).eq."neiiiIRDens") then
              weights%neiiiIRDens = weight
              cycle
            !medium ionisation temperatures
            elseif (trim(quantity).eq."oiiiTemp") then
              weights%oiiiTemp = weight
              cycle
            elseif (trim(quantity).eq."siiiTemp") then
              weights%siiiTemp = weight
              cycle
            elseif (trim(quantity).eq."ariiiTemp") then
              weights%ariiiTemp = weight
              cycle
            elseif (trim(quantity).eq."neiiiTemp") then
              weights%neiiiTemp = weight
              cycle
            elseif (trim(quantity).eq."neiiiIRTemp") then
              weights%neiiiIRTemp = weight
              cycle
            elseif (trim(quantity).eq."oiiiIRTemp") then
              weights%oiiiIRTemp = weight
              cycle
            elseif (trim(quantity).eq."oiiiUVTemp") then
              weights%oiiiUVTemp = weight
              cycle
            !high ionisation densities
            elseif (trim(quantity).eq."neivDens") then
              weights%neivDens = weight
              cycle
            !high ionisation temperatures
            elseif (trim(quantity).eq."arvTemp") then
              weights%arvTemp = weight
              cycle
            elseif (trim(quantity).eq."nevTemp") then
              weights%nevTemp = weight
              cycle
            !balmer weights for extinction calculation
            elseif (trim(quantity).eq."ha") then
              weights%ha = weight
              cycle
            elseif (trim(quantity).eq."hg") then
              weights%hg = weight
              cycle
            elseif (trim(quantity).eq."hd") then
              weights%hd = weight
              cycle
            !helium abundance weights
            elseif (trim(quantity).eq."he4471") then
              weights%he4471 = weight
              cycle
            elseif (trim(quantity).eq."he5876") then
              weights%he5876 = weight
              cycle
            elseif (trim(quantity).eq."he6678") then
              weights%he6678 = weight
              cycle
            elseif (ILs(get_ion(quantity(1:11),ILs))%location .gt. 0) then !it's a CEL, get its location in the linelist array to set the weight
              linelist(ILs(get_ion(quantity(1:11),ILs))%location)%weight = weight
            endif
          endif
        enddo
        111 continue

!where the weight is the observed flux, set it here

        where (linelist%weight .lt. 0)
          linelist%weight = linelist%intensity
        endwhere

end subroutine setweights

end module
