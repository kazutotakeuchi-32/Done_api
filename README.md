# DB設計

## Usersテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|name|string|null:false|
|email|string|null:false,unique: true|
|avatar|string|
|admin|boolean|default: false|
|password|string|null:false,unique: true|
|entry_id|integer|null:false,foreign_key:true|

### Association
has_one_attached :image<br>
has_many :draft_learns<br>
has_many :learns<br>
has_many :entries<br>
has_many :entry_to_rooms ,through: :entries, source: :room<br>
has_many :messages<br>
has_many :message_to_rooms ,through: :entries, source: :room<br>
has_many :likes<br>
has_many :learn_likes,through: :likes, source: :learn<br>
has_many :draft_learn_likes,through: :likes, source: :draft_learn<br>
has_many :relationships<br>
has_many :followings,through: :relationships, source: :follow<br>
has_many :reverse_of_relationships,class_name: 'Relationship',foreign_key: :follow_id<br>
has_many :followers,through: :reverse_of_relationships,source: :user<br>
has_many :reads<br>
has_many :sender_notifications, class_name: "Notification", foreign_key: "sender_id", dependent: :destroy<br>
has_many :receiver_notifications, class_name: "Notification", foreign_key: "receiver_id", dependent: :destroy

<!-- has_many :notifications -->

## Learnsテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|content|string|null:false|
|time|integer|null:false|
|achievement_rate|integer|null:false|
|user_id|integer|null:false,foreign_key:true|
|draft_lern_id |integer|null:false,foreign_key:true|

### Association
belongs_to :user<br>
belongs_to :draftlerning<br>
has_many   :likes

## Draftlearnsテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|content|string|null:false|
|time|integer|null:false|
|user_id|integer|null:false,foreign_key:true|

### Association
belongs_to : user <br>
has_one    : draftlern<br>
has_many :likes

## Likesテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|user_id|integer|null:false,foreign_key:true|
|learn_id|integer|null:false,foreign_key:true|
|draft_learn_id|integer|null:false,foregin_key:true|
### Association
belongs_to : user <br>
belongs_to : learn<br>
belongs_to : draft_learn

## Relationshipsテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|user_id|integer|null:false,foreign_key:true|
|follow_id|integer|null:false,foreign_key:true|
### Association
belongs_to :user <br>
belongs_to :follow, class_name: 'User'

## Messagesテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|message|string|null:false|
|user_id|integer|null:false,foreign_key:true|
|room_id|integer|null:false,foreign_key:true|
### Association
belong_to : user <br>
belong_to : room <br>
has_one   :read

## Roomsテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|user_id|integer|null:false,foreign_key:true|

### Association
has_many :entries<br>
has_many :entry_to_users ,through: :entries, source: :user<br>
has_many :messages<br>
has_many :message_to_users ,through: :entries, source: :user

## Entriesテーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|user_id|integer|null:false,foreign_key:true|
|room_id|integer|null:false,foreign_key:true|

### Association
belong_to : user <br>
belong_to : room

### Readsテーブル
Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|user_id|integer|null:false,foreign_key:true|
|message_id|integer|null:false,foreign_key:true|
|room_id|integer|null:false,foreign_key:true|

### Association
belong_to : user <br>
belong_to : message

### Notificationsテーブル
Column|Type|Options|
|------|----|-------|
|id|integer|null:false|
|kind|string|null:false|
|checked|boolean|null:false|
|sender_id|references |foreign_key:{ to_table: :users }|null:false|optional:true|
|receiver_id|references|foreign_key:{ to_table: :users }|null:false|optional:true|
|message_id|integer|
|learn_id|integer|
|draft_learn_id|integer|
|follow_id|integer|

### Association
belongs_to :sender, class_name: 'User', foreign_key: 'sender_id', optional: true <br>
belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id', optional: true<br>
belong_to : message , optional: true<br>
belong_to : like    , optional: true<br>
