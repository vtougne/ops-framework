[[_TOC_]]


# sample

## send_data_to_partners 


### jobs
Name | cmd
---- | ---
extract_data | extrator --scope = partners \ <br>  --out = {{ OPS_DATA_PATH }}/extracted_data.json&quot
transform_data | transformer --scope = partners \ <br> --out = {{ OPS_DATA_PATH }}/extracted_data.json&quot
send_data | cmd: sender --partner alll

#### send_data_to_partners
```mermaid
graph TD

  subgraph send_data_to_partners
    extract_data["Extract Data scope: partner "]
    transform_data["encrypt "]
    extract_data --> transform_data
    transform_data --> send_data
  end
```


