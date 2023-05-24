-- --------------------------------------------------------------------
--Copyright©2006 by the Institute of Electrical and Electronics Engineers, Inc.
-- Three Park Avenue
-- New York, NY 10016-5997, USA
-- All rights reserved.
-- 
-- This document is an unapproved draft of a proposed IEEE Standard. As such,
-- this document is subject to change. USE AT YOUR OWN RISK! Because this
--  is an unapproved draft, this document must not be utilized for any 
-- conformance/compliance purposes. Permission is hereby granted for IEEE 
-- Standards Committee participants to reproduce this document for purposes 
-- of IEEE standardization activities only. Prior to submitting this document 
-- to another standards development organization for standardization 
-- activities, permission must first be obtained from the Manager, Standards 
-- Licensing and Contracts, IEEE Standards Activities Department. Other 
-- entities seeking permission to reproduce this document, in whole or in 
-- part, must obtain permission from the Manager, Standards Licensing and 
-- Contracts, IEEE Standard Activities Department.
--
-- IEEE Standards Activities Department
-- Standards Licensing and Contracts
-- 445 Hoes Lane, P.O. Box 1331
-- Piscataway, NJ 08855-1331, USA
--
-- Title      :  FLOAT_PKG < IEEE std 1076 >
--
--   Library   :  This package shall be compiled into a library 
--                symbolically named IEEE.
--
--   Developers:  IEEE DASC FPHDL Working Group, PAR 1076.3
--
--   Purpose   :  Floating point HDL package, allows for the binary
--                representation of floating point numbers.
--
--   Limitation:  
--
--
-- --------------------------------------------------------------------
-- Version    : $Revision: 1.3 $
-- Date       : $Date: 2006-09-21 10:32:42-04 $
-- --------------------------------------------------------------------

library ieee;

package float_pkg is new IEEE.float_generic_pkg
  generic map (
    float_exponent_width => 8,    -- float32'high
    float_fraction_width => 23,   -- -float32'low
    float_round_style    => IEEE.math_utility_pkg.round_nearest,  -- round nearest algorithm
    float_denormalize    => true,  -- Use IEEE extended floating
    float_check_error    => true,  -- Turn on NAN and overflow processing
    float_guard_bits     => 3,     -- number of guard bits
    no_warning           => false  -- show warnings
    );

