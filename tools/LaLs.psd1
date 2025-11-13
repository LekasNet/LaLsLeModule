#
# �������� ������ ��� ������ "PSGet_LaLs".
#
# �������: lekas
#
# ���� ��������: 07.10.2024
#

@{

# ���� ������ �������� ��� ��������� ������, ��������� � ���� ����������.
RootModule = 'LaLs.psm1'

# ����� ������ ������� ������.
ModuleVersion = '1.0.0'

# �������������� ������� PSEditions
# CompatiblePSEditions = @()

# ���������� ������������� ������� ������
GUID = 'aaeb3c92-3e49-4f54-96cc-13ddf0d67fdf'

# ����� ������� ������
Author = 'lekas'

# ��������, ��������� ������ ������, ��� ��� ���������
CompanyName = 'LekasNoOne'

# ��������� �� ��������� ������ �� ������
Copyright = '(c) 2025 lek4s. All rights reserved.'

# �������� ������� ������� ������
Description = 'This module provides the `la` command for listing files and directories with color coding and formatting options.'

# ����������� ����� ������ ����������� Windows PowerShell, ����������� ��� ������ ������� ������
# PowerShellVersion = ''

# ��� ���� Windows PowerShell, ������������ ��� ������ ������� ������
# PowerShellHostName = ''

# ����������� ����� ������ ���� Windows PowerShell, ����������� ��� ������ ������� ������
# PowerShellHostVersion = ''

# ����������� ����� ������ Microsoft .NET Framework, ����������� ��� ������� ������. ��� ������������ ���������� ������������� ������ ��� ������� PowerShell, ���������������� ��� �����������.
# DotNetFrameworkVersion = ''

# ����������� ����� ������ ����� CLR (������������ ����� ����������), ����������� ��� ������ ������� ������. ��� ������������ ���������� ������������� ������ ��� ������� PowerShell, ���������������� ��� �����������.
# CLRVersion = ''

# ����������� ���������� (���, X86, AMD64), ����������� ��� ����� ������
# ProcessorArchitecture = ''

# ������, ������� ���������� ������������� � ���������� ����� ����� ��������������� ������� ������
# RequiredModules = @()

# ������, ������� ������ ���� ��������� ����� ��������������� ������� ������
# RequiredAssemblies = @()

# ����� �������� (PS1), ������� ����������� � ����� ���������� ������� ����� �������� ������� ������.
# ScriptsToProcess = @()

# ����� ���� (.ps1xml), ������� ����������� ��� ������� ������� ������
# TypesToProcess = @()

# ����� ������� (PS1XML-�����), ������� ����������� ��� ������� ������� ������
# FormatsToProcess = @()

# ������ ��� ������� � �������� ��������� ������� ������, ���������� � ��������� RootModule/ModuleToProcess
# NestedModules = @()

# � ����� ����������� ����������� ������������������ ������� ��� �������� �� ����� ������ �� ���������� �������������� ����� � �� ������� ������. ����������� ������ ������, ���� ��� ������� ��� ��������.
FunctionsToExport = 'la'

# � ����� ����������� ����������� ������������������ ���������� ��� �������� �� ����� ������ �� ���������� �������������� ����� � �� ������� ������. ����������� ������ ������, ���� ��� ����������� ��� ��������.
CmdletsToExport = '*'

# ���������� ��� �������� �� ������� ������
VariablesToExport = '*'

# � ����� ����������� ����������� ������������������ ���������� ��� �������� �� ����� ������ �� ���������� �������������� ����� � �� ������� ������. ����������� ������ ������, ���� ��� ����������� ��� ��������.
AliasesToExport = '*'

# ������� DSC ��� �������� �� ����� ������
# DscResourcesToExport = @()

# ������ ���� �������, �������� � ����� ������� ������
# ModuleList = @()

# ������ ���� ������, �������� � ����� ������� ������
# FileList = @()

# ������ ������ ��� �������� � ������, ��������� � ��������� RootModule/ModuleToProcess. �� ����� ����� ��������� ���-������� PSData � ��������������� ����������� ������, ������� ������������ � PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/LekasNet/LaLsLeModule/blob/main/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/LekasNet/LaLsLeModule'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        RequireLicenseAcceptance = $true

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

 } # End of PrivateData hashtable

# ��� URI ��� HelpInfo ������� ������
# HelpInfoURI = ''

# ������� �� ��������� ��� ������, ���������������� �� ����� ������. �������������� ������� �� ��������� � ������� ������� Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

