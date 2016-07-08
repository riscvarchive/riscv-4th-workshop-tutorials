-- ********************************************************************/
-- Actel Corporation Proprietary and Confidential
-- Copyright 2009 Actel Corporation. All rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- Description: components definition
--
-- Revision Information:
-- Date     Description
-- 26Oct09  Initial version.
--
-- SVN Revision Information:
-- SVN $Revision: $
-- SVN $Date: $
--
-- Resolved SARs:
-- SAR      Date    Who Description
-- Notes:
--
-- *********************************************************************/

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package components is
  COMPONENT COREAHBTOAPB3
   GENERIC (

      -- ---------------------------------------------------------------------
      -- Parameters
      -- ---------------------------------------------------------------------
      -- Device Family parameter
      FAMILY               : INTEGER := 17
   );
   PORT (
      -- AHBL interface
      HCLK       : IN STD_LOGIC;
      HRESETN    : IN STD_LOGIC;
      HSEL       : IN STD_LOGIC;
      HADDR      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      HWRITE     : IN STD_LOGIC;
      HREADY     : IN STD_LOGIC;
      HTRANS    : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      HWDATA     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      HREADYOUT  : OUT STD_LOGIC;
      HRESP      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      HRDATA     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      -- APB interface
      PADDR      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      PWRITE     : OUT STD_LOGIC;
      PENABLE    : OUT STD_LOGIC;
      PWDATA     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      PSEL       : OUT STD_LOGIC;
      PREADY     : IN STD_LOGIC;
      PSLVERR    : IN STD_LOGIC;
      PRDATA     : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
   );
  END COMPONENT;

end components;
