unit DIOTA.Utils.Constants;

  //This unit defines the global constants.

interface

const
  KEY_LENGTH = Integer(6561);

  //This String contains all possible characters of the tryte alphabet
  TRYTE_ALPHABET = '9ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  //The length of an IOTA seed
  SEED_LENGTH = Integer(81);

  //The length of a hash in trits
  HASH_LENGTH_TRITS = Integer(243);

  //The length of an address without checksum in trytes
  ADDRESS_LENGTH_WITHOUT_CHECKSUM = Integer(81);

  //The length of an address with checksum in trytes
  ADDRESS_LENGTH_WITH_CHECKSUM = Integer(90);

  //The length of a message
  MESSAGE_LENGTH = Integer(2187);

  //Size of a full transaction, whether it has been attached or not.
  TRANSACTION_SIZE = Integer(2673);

  //The length of an tag
  TAG_LENGTH = Integer(27);

  //Minimum security level of an address
  MIN_SECURITY_LEVEL = Integer(1);

  //Maximum security level of an address
  MAX_SECURITY_LEVEL = Integer(3);

  INVALID_TRYTES_INPUT_ERROR = 'Invalid trytes provided.';
  INVALID_HASHES_INPUT_ERROR = 'Invalid hashes provided.';
  INVALID_TAIL_HASH_INPUT_ERROR = 'Invalid tail hash provided.';
  INVALID_SEED_INPUT_ERROR = 'Invalid seed provided.';
  INVALID_SECURITY_LEVEL_INPUT_ERROR = 'Invalid security level provided.';
  INVALID_INDEX_INPUT_ERROR = 'Invalid index provided.';
  INVALID_ATTACHED_TRYTES_INPUT_ERROR = 'Invalid attached trytes provided.';
  INVALID_TRANSFERS_INPUT_ERROR = 'Invalid transfers provided.';
  INVALID_ADDRESSES_INPUT_ERROR = 'Invalid addresses provided.';
  INVALID_INPUT_ERROR = 'Invalid input provided.';
  INVALID_TAG_ERROR = 'Invalid tag provided.';

  INVALID_BUNDLE_ERROR = 'Invalid bundle.';
  INVALID_BUNDLE_SUM_ERROR = 'Invalid bundle sum.';
  INVALID_BUNDLE_HASH_ERROR = 'Invalid bundle hash.';
  INVALID_SIGNATURES_ERROR = 'Invalid signatures.';
  INVALID_VALUE_TRANSFER_ERROR = 'Invalid value transfer: the transfer does not require a signature.';

  TRANSACTION_NOT_FOUND = 'Transaction was not found on the node';

  NOT_ENOUGH_BALANCE_ERROR = 'Not enough balance.';
  NO_REMAINDER_ADDRESS_ERROR = 'No remainder address defined.';

  GET_TRYTES_RESPONSE_ERROR = 'Get trytes response was null.';
  GET_BUNDLE_RESPONSE_ERROR = 'Get bundle response was null.';
  GET_INCLUSION_STATE_RESPONSE_ERROR = 'Get inclusion state response was null.';

  SENDING_TO_USED_ADDRESS_ERROR = 'Sending to a used address.';
  PRIVATE_KEY_REUSE_ERROR = 'Private key reuse detect!';
  SEND_TO_INPUTS_ERROR = 'Send to inputs!';

  EMPTY_BUNDLE_ERROR = 'Need at least one transaction in the bundle';
  INVALID_DEPTH_ERROR = 'Depth must be >= 0';
  INVALID_WEIGHT_MAGNITUDE_ERROR = 'MinWeightMagnitude must be > 0';

implementation

end.
