# # SPDX-License-Identifier: AGPL-3.0-or-later

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_block_timestamp
from starkware.cairo.common.math_cmp import is_le
from starkware.starknet.common.syscalls import get_caller_address

# # @title Example Whitelist task.
# # @description Create a whitelist and allow it to access a smart contract function.
# # @author vaibhavgeek <github.com/vaibhavgeek>

#############################################
# #                  STORAGE               ##
#############################################

@storage_var
func __whitelist(address : felt) -> (res : felt):
end

@storage_var
func __owner() -> (owner_address : felt):
end

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    owner_address : felt
):
    __owner.write(value=owner_address)
    return ()
end
#############################################
# #               FUNCTIONS                ##
#############################################

@external
func checkWhitelist{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    address : felt
) -> (output : felt):
    let (op) = __whitelist.read(address)
    return (op)
end

@external
func revokeAccess{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    address : felt
) -> (output : felt):
    let (caller_address) = get_caller_address()
    let (owner) = __owner.read()
    if caller_address == owner:
        __whitelist.write(address, 0)
        return (1)
    else:
        return (0)
    end
end

@external
func whitelistAddress{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    address : felt
) -> (address : felt):
    let (caller_address) = get_caller_address()
    let (owner) = __owner.read()
    if caller_address == owner:
        __whitelist.write(address, 1)
        return (1)
    else:
        return (0)
    end
end
