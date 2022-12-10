variable "compartment_ocid" {
  description = ""

}

variable "region" {
  description = ""
  default="eu-frankfurt-1"
}

# variable "ssh_public_key_path" {
#   description = ""
# }


variable "AD_number" {
  type          = number
  description   = ""
  default       = 1
}

variable "node_count" {
  type          = number
  description   = ""
  default       = 2
}

variable "ocpu_count" {
  type          = number
  description   = ""
  default       = 2
}




variable "InstanceImageOCID" {
  type = map(string)

  default = {
    // See https://docs.us-phoenix-1.oraclecloud.com/images/
    // Oracle-provided image "Oracle-Linux-7.5-2018.10.16-0"
    af-johannesburg-1 ="ocid1.image.oc1.af-johannesburg-1.aaaaaaaa6dl66bskujdos2u54asrierq5zilbtvmcqaegmexsdtfyu2456nq"
    ap-chuncheon-1    ="ocid1.image.oc1.ap-chuncheon-1.aaaaaaaalf6iify43wzw6yab4vfvouf23fl3bawpzxqufnodgilk6g5n47gq"
    ap-hyderabad-1    ="ocid1.image.oc1.ap-hyderabad-1.aaaaaaaaiwm5lmxjqbcws2bdpheqdvdt5f5e5p5hthbb3zmnnx3c3hocr5ca"
    ap-melbourne-1    ="ocid1.image.oc1.ap-melbourne-1.aaaaaaaayv3eypjn6ftwbo7qvnb6773msnmi3gzaepreoemoqobdzkeh3l3a"
    ap-mumbai-1       ="ocid1.image.oc1.ap-mumbai-1.aaaaaaaam3wmp3qlcafcjb2o2zkyk6uerhh7ggr6vmhfgffy6efpkxlva2qq"
    ap-osaka-1        ="ocid1.image.oc1.ap-osaka-1.aaaaaaaaxyyzz5mz2ql347x5riaqbq5eqebos77ewqmmjlnkkadsyaa7edea"
    ap-seoul-1        ="ocid1.image.oc1.ap-seoul-1.aaaaaaaa74xvrwk3yuwz5gkgq2lhaelwk54tjsgfsxdibu6pp2pptsiwul7a"
    ap-singapore-1    ="ocid1.image.oc1.ap-singapore-1.aaaaaaaafmgn36424lyzobm37fbemdlwclobfe6y2zrqzfpms7r37bsjxsfq"
    ap-sydney-1       ="ocid1.image.oc1.ap-sydney-1.aaaaaaaa5cv4wmjfam7aaomdkehxby2e3wxkwrjqecx63arszsm3jgiwempq"
    ap-tokyo-1        ="ocid1.image.oc1.ap-tokyo-1.aaaaaaaapaqhohdn4c47jygpttxkcjq3h3idniv273ybfyiwfrz2lqiyzw3q"
    ca-montreal-1     ="ocid1.image.oc1.ca-montreal-1.aaaaaaaacsk2autwgcwt2r5mxfxc3friudrhmfs4kut2dcjffddphpmtbczq"
    ca-toronto-1      ="ocid1.image.oc1.ca-toronto-1.aaaaaaaau33j2x6j2wyz2qyx5fud2rwg2il6a7iljsueo2h73u7boh3qatla"
    eu-amsterdam-1    ="ocid1.image.oc1.eu-amsterdam-1.aaaaaaaacnvnpkflyznmbkojtuarbba5vbiqsngveoskd472e5gmde6jmilq"
    eu-frankfurt-1    ="ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaqej4hwioz33mm23ot2d67hzi36nxqwdi2hr2fimhmqfxs6c2kxxa"
    eu-marseille-1    ="ocid1.image.oc1.eu-marseille-1.aaaaaaaakumd65l77atl3afevstz5t5ahwvogzi3cr76fogo3y5xw3tspcjq"
    eu-milan-1        ="ocid1.image.oc1.eu-milan-1.aaaaaaaamm5jcttx2aoisse4rhfhxw653l3qad7b744rczrvakebvviyodia"
    eu-paris-1        ="ocid1.image.oc1.eu-paris-1.aaaaaaaanztskmcztdl5mcxap2scz4mkojza44m67nu6mtjfgitp3i5ndqsq"
    eu-stockholm-1    ="ocid1.image.oc1.eu-stockholm-1.aaaaaaaa5jqivtab4girnuowdkpjkeqq5p4hooowiw2aeopdkcssvegucywq"
    eu-zurich-1       ="ocid1.image.oc1.eu-zurich-1.aaaaaaaacxtajytvr4v546ymwysl4nfhu5uh7emtk2cjrxvmkuobujtmntua"
    il-jerusalem-1    ="ocid1.image.oc1.il-jerusalem-1.aaaaaaaaiji5mfqjadocfvlov6thasuvq3nf62ob2ikoqt3dmzslj74dty7q"
    me-abudhabi-1     ="ocid1.image.oc1.me-abudhabi-1.aaaaaaaao5s57gygjzua3r4popugboy75y7nxouym5w3dt2zerjb2kmtv6hq"
    me-dubai-1        ="ocid1.image.oc1.me-dubai-1.aaaaaaaagae4wy35lakovnctyve74ecgduou3vw7nlbmy7rigyx3d5c4qmfa"
    me-jeddah-1       ="ocid1.image.oc1.me-jeddah-1.aaaaaaaai7ktdvq6l6ofhy5y3sowktrf3twvlv7ahihlerec3twxwwczfdwa"
    mx-queretaro-1    ="ocid1.image.oc1.mx-queretaro-1.aaaaaaaaenf426pthzy6lskyqe7ilqu7vfm36uyepuvi6bfc4jysmnfkjk6a"
    sa-santiago-1     ="ocid1.image.oc1.sa-santiago-1.aaaaaaaaunmwbk32l2fu54weqxfnib67thfintza6w2loi35pfqorjs5jpra"
    sa-saopaulo-1     ="ocid1.image.oc1.sa-saopaulo-1.aaaaaaaa5zrqapicmyowufjjd5msmmxjowjm452novtvbbk4eludy2t3w2ja"
    sa-vinhedo-1      ="ocid1.image.oc1.sa-vinhedo-1.aaaaaaaakjyre7yuv5pvf4rmrnocraihvunflhpgj53mc6cd3nshlxystbla"
    uk-cardiff-1      ="ocid1.image.oc1.uk-cardiff-1.aaaaaaaahzz5tqeylmtrtrsldh53yypb7be4xcrb77zebzzurlb2gtvfndwq"
    uk-london-1       ="ocid1.image.oc1.uk-london-1.aaaaaaaaasio7r4u3nrbuifbzu54fohjui4jml7qsaw3wgr3cmzihwxma2pq"
    us-ashburn-1      ="ocid1.image.oc1.iad.aaaaaaaadl5lond67wh3qx64qjpzh2apqmnranxaorhww3vlxxoipjqa53lq"
    us-phoenix-1      ="ocid1.image.oc1.phx.aaaaaaaaf3pg3rvozrtshjdeqmtrcpcauwkdketd63ms5h2dmbr72kcgtita"
    us-sanjose-1      ="ocid1.image.oc1.us-sanjose-1.aaaaaaaaol3zp7d4jqxh7pj4mv5ezhj6thvfuzesemudbkgl6zj6bq5dt52a"
    
  }
}

