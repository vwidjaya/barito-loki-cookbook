#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook:: windows
# Library:: version
#
# Copyright:: 2011-2018, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_relative 'wmi_helper' if RUBY_PLATFORM =~ /mswin|mingw32|windows/

module Windows
  class Version
    # http://msdn.microsoft.com/en-us/library/ms724833(v=vs.85).aspx

    # Suite Masks
    # Microsoft BackOffice components are installed.
    VER_SUITE_BACKOFFICE = 0x00000004 unless defined?(VER_SUITE_BACKOFFICE)
    # Windows Server 2008 Datacenter, Windows Server 2003, Datacenter Edition, or Windows 2000 Datacenter Server is installed.
    VER_SUITE_DATACENTER = 0x00000080 unless defined?(VER_SUITE_DATACENTER)
    # Windows Server 2008 Enterprise, Windows Server 2003, Enterprise Edition, or Windows 2000 Advanced Server is installed. Refer to the Remarks section for more information about this bit flag.
    VER_SUITE_ENTERPRISE = 0x00000002 unless defined?(VER_SUITE_ENTERPRISE)
    # Windows XP Embedded is installed.
    VER_SUITE_EMBEDDEDNT = 0x00000040 unless defined?(VER_SUITE_EMBEDDEDNT)
    # Windows Vista Home Premium, Windows Vista Home Basic, or Windows XP Home Edition is installed.
    VER_SUITE_PERSONAL = 0x00000200 unless defined?(VER_SUITE_PERSONAL)
    # Remote Desktop is supported, but only one interactive session is supported. This value is set unless the system is running in application server mode.
    VER_SUITE_SINGLEUSERTS = 0x00000100 unless defined?(VER_SUITE_SINGLEUSERTS)
    # Microsoft Small Business Server was once installed on the system, but may have been upgraded to another version of Windows. Refer to the Remarks section for more information about this bit flag.
    VER_SUITE_SMALLBUSINESS = 0x00000001 unless defined?(VER_SUITE_SMALLBUSINESS)
    # Microsoft Small Business Server is installed with the restrictive client license in force. Refer to the Remarks section for more information about this bit flag.
    VER_SUITE_SMALLBUSINESS_RESTRICTED = 0x00000020 unless defined?(VER_SUITE_SMALLBUSINESS_RESTRICTED)
    # Terminal Services is installed. This value is always set.
    # If VER_SUITE_TERMINAL is set but VER_SUITE_SINGLEUSERTS is not set, the system is running in application server mode.
    VER_SUITE_TERMINAL = 0x00000010 unless defined?(VER_SUITE_TERMINAL)
    # Windows Home Server is installed.
    VER_SUITE_WH_SERVER = 0x00008000 unless defined?(VER_SUITE_WH_SERVER)

    # Product Type
    # The system is a domain controller and the operating system is Windows Server 2012, Windows Server 2008 R2, Windows Server 2008, Windows Server 2003, or Windows 2000 Server.
    VER_NT_DOMAIN_CONTROLLER = 0x0000002 unless defined?(VER_NT_DOMAIN_CONTROLLER)
    # The operating system is Windows Server 2012, Windows Server 2008 R2, Windows Server 2008, Windows Server 2003, or Windows 2000 Server.
    # Note that a server that is also a domain controller is reported as VER_NT_DOMAIN_CONTROLLER, not VER_NT_SERVER.
    VER_NT_SERVER = 0x0000003 unless defined?(VER_NT_SERVER)
    # The operating system is Windows 7, Windows Vista, Windows XP Professional, Windows XP Home Edition, or Windows 2000 Professional.
    VER_NT_WORKSTATION = 0x0000001 unless defined?(VER_NT_WORKSTATION)

    # http://msdn.microsoft.com/en-us/library/ms724358(v=vs.85).aspx
    unless defined?(SKU)
      SKU = {
        0x00000006 => { ms_const: 'PRODUCT_BUSINESS', name: 'Business' },
        0x00000010 => { ms_const: 'PRODUCT_BUSINESS_N', name: 'Business N' },
        0x00000012 => { ms_const: 'PRODUCT_CLUSTER_SERVER', name: 'HPC Edition' },
        0x00000008 => { ms_const: 'PRODUCT_DATACENTER_SERVER', name: 'Server Datacenter (full installation)' },
        0x0000000C => { ms_const: 'PRODUCT_DATACENTER_SERVER_CORE', name: 'Server Datacenter (core installation)' },
        0x00000027 => { ms_const: 'PRODUCT_DATACENTER_SERVER_CORE_V', name: 'Server Datacenter without Hyper-V (core installation)' },
        0x00000025 => { ms_const: 'PRODUCT_DATACENTER_SERVER_V', name: 'Server Datacenter without Hyper-V (full installation)' },
        0x00000004 => { ms_const: 'PRODUCT_ENTERPRISE', name: 'Enterprise' },
        0x00000046 => { ms_const: 'PRODUCT_ENTERPRISE_E', name: 'Not supported' },
        0x0000001B => { ms_const: 'PRODUCT_ENTERPRISE_N', name: 'Enterprise N' },
        0x0000000A => { ms_const: 'PRODUCT_ENTERPRISE_SERVER', name: 'Server Enterprise (full installation)' },
        0x0000000E => { ms_const: 'PRODUCT_ENTERPRISE_SERVER_CORE', name: 'Server Enterprise (core installation)' },
        0x00000029 => { ms_const: 'PRODUCT_ENTERPRISE_SERVER_CORE_V', name: 'Server Enterprise without Hyper-V (core installation)' },
        0x0000000F => { ms_const: 'PRODUCT_ENTERPRISE_SERVER_IA64', name: 'Server Enterprise for Itanium-based Systems' },
        0x00000026 => { ms_const: 'PRODUCT_ENTERPRISE_SERVER_V', name: 'Server Enterprise without Hyper-V (full installation)' },
        0x00000002 => { ms_const: 'PRODUCT_HOME_BASIC', name: 'Home Basic' },
        0x00000043 => { ms_const: 'PRODUCT_HOME_BASIC_E', name: 'Not supported' },
        0x00000005 => { ms_const: 'PRODUCT_HOME_BASIC_N', name: 'Home Basic N' },
        0x00000003 => { ms_const: 'PRODUCT_HOME_PREMIUM', name: 'Home Premium' },
        0x00000044 => { ms_const: 'PRODUCT_HOME_PREMIUM_E', name: 'Not supported' },
        0x0000001A => { ms_const: 'PRODUCT_HOME_PREMIUM_N', name: 'Home Premium N' },
        0x0000002A => { ms_const: 'PRODUCT_HYPERV', name: 'Microsoft Hyper-V Server' },
        0x0000001E => { ms_const: 'PRODUCT_MEDIUMBUSINESS_SERVER_MANAGEMENT', name: 'Windows Essential Business Server Management Server' },
        0x00000020 => { ms_const: 'PRODUCT_MEDIUMBUSINESS_SERVER_MESSAGING', name: 'Windows Essential Business Server Messaging Server' },
        0x0000001F => { ms_const: 'PRODUCT_MEDIUMBUSINESS_SERVER_SECURITY', name: 'Windows Essential Business Server Security Server' },
        0x00000030 => { ms_const: 'PRODUCT_PROFESSIONAL', name: 'Professional' },
        0x00000045 => { ms_const: 'PRODUCT_PROFESSIONAL_E', name: 'Not supported' },
        0x00000031 => { ms_const: 'PRODUCT_PROFESSIONAL_N', name: 'Professional N' },
        0x00000067 => { ms_const: 'PRODUCT_PROFESSIONAL_WMC', name: 'Professional with Media Center' },
        0x00000018 => { ms_const: 'PRODUCT_SERVER_FOR_SMALLBUSINESS', name: 'Windows Server 2008 for Windows Essential Server Solutions' },
        0x00000023 => { ms_const: 'PRODUCT_SERVER_FOR_SMALLBUSINESS_V', name: 'Windows Server 2008 without Hyper-V for Windows Essential Server Solutions' },
        0x00000021 => { ms_const: 'PRODUCT_SERVER_FOUNDATION', name: 'Server Foundation' },
        0x00000022 => { ms_const: 'PRODUCT_HOME_PREMIUM_SERVER', name: 'Windows Home Server 2011' },
        0x00000032 => { ms_const: 'PRODUCT_SB_SOLUTION_SERVER', name: 'Windows Small Business Server 2011 Essentials' },
        0x00000013 => { ms_const: 'PRODUCT_HOME_SERVER', name: 'Windows Storage Server 2008 R2 Essentials' },
        0x00000009 => { ms_const: 'PRODUCT_SMALLBUSINESS_SERVER', name: 'Windows Small Business Server' },
        0x00000038 => { ms_const: 'PRODUCT_SOLUTION_EMBEDDEDSERVER', name: 'Windows MultiPoint Server' },
        0x00000007 => { ms_const: 'PRODUCT_STANDARD_SERVER', name: 'Server Standard (full installation)' },
        0x0000000D => { ms_const: 'PRODUCT_STANDARD_SERVER_CORE', name: 'Server Standard (core installation)' },
        0x00000028 => { ms_const: 'PRODUCT_STANDARD_SERVER_CORE_V', name: 'Server Standard without Hyper-V (core installation)' },
        0x00000024 => { ms_const: 'PRODUCT_STANDARD_SERVER_V', name: 'Server Standard without Hyper-V (full installation)' },
        0x0000000B => { ms_const: 'PRODUCT_STARTER', name: 'Starter' },
        0x00000042 => { ms_const: 'PRODUCT_STARTER_E', name: 'Not supported' },
        0x0000002F => { ms_const: 'PRODUCT_STARTER_N', name: 'Starter N' },
        0x00000017 => { ms_const: 'PRODUCT_STORAGE_ENTERPRISE_SERVER', name: 'Storage Server Enterprise' },
        0x00000014 => { ms_const: 'PRODUCT_STORAGE_EXPRESS_SERVER', name: 'Storage Server Express' },
        0x00000015 => { ms_const: 'PRODUCT_STORAGE_STANDARD_SERVER', name: 'Storage Server Standard' },
        0x00000016 => { ms_const: 'PRODUCT_STORAGE_WORKGROUP_SERVER', name: 'Storage Server Workgroup' },
        0x00000000 => { ms_const: 'PRODUCT_UNDEFINED', name: 'An unknown product' },
        0x00000001 => { ms_const: 'PRODUCT_ULTIMATE', name: 'Ultimate' },
        0x00000047 => { ms_const: 'PRODUCT_ULTIMATE_E', name: 'Not supported' },
        0x0000001C => { ms_const: 'PRODUCT_ULTIMATE_N', name: 'Ultimate N' },
        0x00000011 => { ms_const: 'PRODUCT_WEB_SERVER', name: 'Web Server (full installation)' },
        0x0000001D => { ms_const: 'PRODUCT_WEB_SERVER_CORE', name: 'Web Server (core installation)' }
      }.freeze
    end

    attr_reader :major_version, :minor_version, :build_number, :service_pack_major_version, :service_pack_minor_version
    attr_reader :version, :product_type, :product_suite, :sku

    def initialize
      raise NotImplementedError, 'only valid on Windows platform' unless RUBY_PLATFORM =~ /mswin|mingw32|windows/

      @version, @product_type, @product_suite, @sku, @service_pack_major_version, @service_pack_minor_version = get_os_info
      @major_version, @minor_version, @build_number = version.split('.').map(&:to_i)
    end

    unless defined?(WIN_VERSIONS)
      WIN_VERSIONS = {
        'Windows 10' => { major: 10, minor: 0, callable: -> { @product_type != VER_NT_WORKSTATION } },
        'Windows Server 2012 R2' => { major: 6, minor: 3, callable: -> { @product_type != VER_NT_WORKSTATION } },
        'Windows 8' => { major: 6, minor: 2, callable: -> { @product_type == VER_NT_WORKSTATION } },
        'Windows Server 2012' => { major: 6, minor: 2, callable: -> { @product_type != VER_NT_WORKSTATION } },
        'Windows 7' => { major: 6, minor: 1, callable: -> { @product_type == VER_NT_WORKSTATION } },
        'Windows Server 2008 R2' => { major: 6, minor: 1, callable: -> { @product_type != VER_NT_WORKSTATION } },
        'Windows Server 2008' => { major: 6, minor: 0, callable: -> { @product_type != VER_NT_WORKSTATION } },
        'Windows Vista' => { major: 6, minor: 0, callable: -> { @product_type == VER_NT_WORKSTATION } },
        'Windows Home Server' => { major: 5, minor: 2, callable: -> { (@product_suite & VER_SUITE_WH_SERVER) == VER_SUITE_WH_SERVER } },
        'Windows XP' => { major: 5, minor: 1 },
        'Windows 2000' => { major: 5, minor: 0 }
      }.freeze
    end

    marketing_names = []

    # General Windows checks
    WIN_VERSIONS.each do |k, v|
      method_name = "#{k.gsub(/\s/, '_').downcase}?"
      define_method(method_name) do
        (@major_version == v[:major]) &&
          (@minor_version == v[:minor]) &&
          (v[:callable] ? v[:callable].call : true)
      end
      marketing_names << [k, method_name]
    end

    define_method(:marketing_name) do
      marketing_names.each do |mn|
        break mn[0] if send(mn[1])
      end
    end

    # Server Type checks
    %w[core full datacenter].each do |m|
      define_method("server_#{m}?") do
        if @sku
          !(SKU[@sku][:name] =~ /#{m}/i).nil?
        else
          false
        end
      end
    end

    private

    # query WMI Win32_OperatingSystem for required OS info
    def get_os_info
      cols = %w[Version ProductType OSProductSuite OperatingSystemSKU ServicePackMajorVersion ServicePackMinorVersion]
      os_info = execute_wmi_query('select * from Win32_OperatingSystem').each.next
      cols.map do |c|
        begin
          wmi_object_property(os_info, c)
        rescue StandardError # OperatingSystemSKU doesn't exist in all versions of Windows
          nil
        end
      end
    end
  end
end
